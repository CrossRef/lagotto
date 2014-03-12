# encoding: UTF-8

# $HeadURL$
# $Id$
#
# Copyright (c) 2009-2014 by Public Library of Science, a non-profit corporation
# http://www.plos.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class RetrievalHistory < ActiveRecord::Base

  belongs_to :retrieval_status
  belongs_to :article
  belongs_to :source

  before_destroy :delete_couchdb_document

  default_scope order("retrieved_at DESC")

  scope :after_days, lambda { |days|
    if ActiveRecord::Base.configurations[Rails.env]['adapter'] == "mysql2"
      joins(:article).where("retrieved_at <= articles.published_on + INTERVAL ? DAY", days)
    else
      joins(:article).where("retrieved_at <= articles.published_on + INTERVAL '? DAY'", days)
    end
  }
  scope :after_months, lambda { |months|
    if ActiveRecord::Base.configurations[Rails.env]['adapter'] == "mysql2"
      joins(:article).where("retrieved_at <= articles.published_on + INTERVAL ? MONTH", months)
    else
      joins(:article).where("retrieved_at <= articles.published_on + INTERVAL '? MONTH'", months)
    end
  }
  scope :until_year, lambda { |year| joins(:article).where("EXTRACT(YEAR FROM retrieved_at) <= ?", year) }
  scope :total, lambda { |duration| where("retrieved_at > ?", Time.zone.now - duration.days) }

  # This is needed to calculate and display the table size
  def self.table_status
    if ActiveRecord::Base.configurations[Rails.env]['adapter'] == "mysql2"
     sql = "SHOW TABLE STATUS LIKE 'retrieval_histories'"
    else
      sql = "SELECT * FROM pg_class WHERE oid = 'public.retrieval_histories'::regclass"
    end
    table_status = ActiveRecord::Base.connection.select_all(sql).first
    Hash[table_status.map {|k, v| [k.to_s.underscore, v] }]
  end

  def data
    if event_count > 0
      data = get_alm_data(id)
    else
      nil
    end
  end

  def events_url
    data["events_url"] unless data.nil?
  end

  def events
    unless data.nil?
      data["events"]
    else
      []
    end
  end

  def metrics
    unless data.blank?
      data["event_metrics"]
    else
      nil
    end
  end

  private

  def delete_couchdb_document
    data_rev = get_alm_rev(id)
    remove_alm_data(id, data_rev)
  end
end