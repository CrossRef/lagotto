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

class Mendeley < Source

  validates_each :url, :url_with_type, :related_articles_url, :api_key do |record, attr, value|
    record.errors.add(attr, "can't be blank") if value.blank?
  end

  def get_data(article, options={})
    raise(ArgumentError, "#{display_name} configuration requires api key") \
      if config.api_key.blank?

    return  { :events => [], :event_count => 0 } if article.doi.blank?
    
    result = []

    # try mendeley uuid first if we have it
     unless article.mendeley.blank?
      result = get_json_data(search_url(article.mendeley), options)
    end

    # try using doi
    if (result.nil? || result.length == 0)
      # doi has to be double encoded.
      result = get_json_data(search_url(CGI.escape(CGI.escape(article.doi)), "doi"), options)
    end

    # querying by doi sometimes fails
    # try pub med id
    if (result.nil? || result.length == 0) && !article.pub_med.nil?
      result = get_json_data(search_url(article.pub_med, "pmid"), options)
    end

    if (result.blank? || !result["error"].nil?)
      { :events => [], 
        :event_count => 0 }
    else
      events_url = result['mendeley_url']

      # event count is the reader number and group number combined
      total = 0
      readers = result['stats']['readers']
      unless readers.nil?
        total += readers
      end

      groups = result['groups']
      unless groups.nil?
        total += groups.length
      end

      related_articles = get_json_data(related_url(result['uuid']), options)
      if related_articles.length > 0
        result[:related] = related_articles['documents']
      end
      
      # store mendeley uuid if we didn't have it
      if article.mendeley.blank?
        article.update_attributes(:mendeley => result['uuid'])
      end

      {:events => result,
       :events_url => events_url,
       :event_count => total,
       :local_id => result['uuid']}
    end

  end

  def search_url(id, id_type = nil)
    if id_type.nil?
      config.url % { :id => id, :api_key => config.api_key }
    else
      config.url_with_type % { :id => id, :doc_type => id_type, :api_key => config.api_key }
    end
  end

  def related_url(uuid)
    config.related_articles_url % { :id => uuid, :api_key => config.api_key}
  end

  def get_json_data(url, options={})
    begin
      result = get_json(url, options)
    rescue => e
      Rails.logger.error("#{display_name} #{e.message}")
      if e.respond_to?('response')
        if e.response.kind_of?(Net::HTTPForbidden)
          # http response 403
          Rails.logger.error "#{display_name} returned 403, they might be throttling us."
        end
        # if the article could not be found by the Mendeley api, continue on (we will get a 404 error)
        # if we get any other error, throw it so it can be handled by the caller (ex. 503)
        unless e.response.kind_of?(Net::HTTPNotFound)
          raise e
        end
      else
        raise e
      end
    end
  end

  def get_config_fields
    [{:field_name => "url", :field_type => "text_area", :size => "90x2"},
     {:field_name => "url_with_type", :field_type => "text_area", :size => "90x2"},
     {:field_name => "related_articles_url", :field_type => "text_area", :size => "90x2"},
     {:field_name => "api_key", :field_type => "text_field"}]
  end

  def url
    config.url
  end

  def url=(value)
    config.url = value
  end

  def url_with_type
    config.url_with_type
  end

  def url_with_type=(value)
    config.url_with_type = value
  end

  def related_articles_url
    config.related_articles_url
  end

  def related_articles_url=(value)
    config.related_articles_url = value
  end

  def api_key
    config.api_key
  end

  def api_key=(value)
    config.api_key = value
  end
end