# $HeadURL$
# $Id$
#
# Copyright (c) 2009-2012 by Public Library of Science, a non-profit corporation
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

  SUCCESS_MSG = "SUCCESS"
  SUCCESS_NODATA_MSG = "SUCCESS WITH NO DATA"
  ERROR_MSG = "ERROR"
  SKIPPED_MSG = "SKIPPED"
  SOURCE_DISABLED = "Source disabled"
  SOURCE_NOT_ACTIVE = "Source not active"
  
  scope :after_days, lambda { |days| joins(:article).where("DATE(retrieved_at) <= TIMESTAMPADD(DAY,?,articles.published_on)", days).order("retrieved_at") }
  scope :after_months, lambda { |months| joins(:article).where("DATE(retrieved_at) <= TIMESTAMPADD(MONTH,?,articles.published_on)", months).order("retrieved_at") }

  def data
    begin
      data = get_alm_data(id)
    rescue => e
      Rails.logger.error "Failed to get data for #{id}. #{e.message}"
      data = nil
    end
  end
  
  def public_url
    data["events_url"] unless data.nil?
  end
  
  def events
    unless data.nil?
      data["events"] 
    else
      []
    end
  end
  
  def pdf
    nil
  end
  
  def html
    nil
  end
  
  def shares
    case source.name
    when "citeulike"
      event_count
    when "mendeley"
      events && events['stats'] ? events['stats']['readers'] : 0
    when "wikipedia"
      events.select {|event| event["namespace"] > 0 }.length
    when "facebook"
      events.inject(0) { |sum, hash| sum + hash[:share_count] }
    else
      nil
    end
  end
  
  def groups
    if source.name == "mendeley"
      events && events['groups'] ? events['groups'].length : 0
    else
      nil
    end
  end
 
  def comments
    case source.name
    when "facebook"
      events.inject(0) { |sum, hash| sum + hash[:comment_count] }
    else
      nil
    end
  end
  
  def likes
    case source.name
    when "facebook"
      events.inject(0) { |sum, hash| sum + hash[:like_count] }
    else
      nil
    end
  end
  
  def citations
    if ["cross_ref","pub_med","researchblogging","nature"].include?(source.name)
      event_count
    elsif source.name == "wikipedia"
      events.select {|event| event["namespace"] == 0 }.length
    else
      nil
    end
  end
  
  def metrics
    { :pdf => pdf, :html => html, :shares => shares, :groups => groups, :comments => comments, :likes => likes, :citations => citations, :total => event_count }
  end
  
  def as_json
    {
        :updated_at => (retrieved_at.nil? ? nil: retrieved_at.to_time),
        :count => event_count
    }
  end

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag!("history", :updated_at => (retrieved_at.nil? ? nil: retrieved_at.to_time), :count => event_count)
  end

end
