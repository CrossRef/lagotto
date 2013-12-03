# encoding: UTF-8

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

class Report < ActiveRecord::Base

  has_and_belongs_to_many :users

  # Reports are sent via delayed_job

  def send_error_report
    ReportMailer.delay(queue: 'mailer', priority: 1).send_error_report(self)
  end

  def send_status_report
    ReportMailer.delay(queue: 'mailer', priority: 1).send_status_report(self)
  end

  def send_disabled_source_report(source_id)
    ReportMailer.delay(queue: 'mailer', priority: 1).send_disabled_source_report(self, source_id)
  end

end
