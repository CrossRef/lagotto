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

class Facebook < Source

  validates_each :url, :access_token do |record, attr, value|
    record.errors.add(attr, "can't be blank") if value.blank?
  end

  def get_data(article, options={})
    raise(ArgumentError, "#{display_name} configuration requires access_token") \
      if config.access_token.blank?
    
    # Fetch the fulltext URL, as it might work better for Facebook than the DOI
    if article.url.blank? and !article.doi.blank?
      begin
        original_url = get_original_url(article.doi_as_url)
        article.update_attributes(:url => original_url)
      rescue => e
        ErrorMessage.create(:exception => e, :message => "Could not get the full url for #{article.doi_as_url} #{e.message}", :source_id => id)
      end
    end
    
    return  { :events => [], :event_count => 0 } if article.url.blank?
    
    query_url = get_query_url(article.url)
    result = get_json(query_url, options)
    
    if result["error"]
      ErrorMessage.create(:class_name => result["error"]["type"], :message => result["error"]["message"], :source_id => id)          
      { :events => [], :event_count => 0 }
    else
      events = result["data"][0]
      { :events => events, :event_count => events["total_count"] }
    end
  end
  
  def get_query_url(query_url, options={})    
    # https://graph.facebook.com/fql?access_token=%{access_token}&q=select%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,%20click_count,%20comments_fbid,%20commentsbox_count%20from%20link_stat%20where%20url%20=%20'%{query_url}'
    URI.escape(config.url % { :access_token => config.access_token, :query_url => query_url }) unless query_url.blank?
  end

  def get_config_fields
    [{:field_name => "url", :field_type => "text_area", :size => "90x2"},
     {:field_name => "access_token", :field_type => "text_field"}]
  end
  
  def url
    config.url
  end

  def url=(value)
    config.url = value
  end

  def access_token
    config.access_token
  end

  def access_token=(value)
    config.access_token = value
  end
end