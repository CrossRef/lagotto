class Nature < Agent
  def get_query_string(options={})
    work = Work.where(id: options.fetch(:work_id, nil)).first
    return {} unless work.present? && work.doi.present?

    work.doi_escaped
  end

  def get_events_url(options={})
    nil
  end

  def get_related_works(result, work)
    Array(result['data']).map do |item|
      item.extend Hashie::Extensions::DeepFetch
      timestamp = get_iso8601_from_time(item.fetch("post", {}).fetch("created_at", nil))
      url = item.fetch("post", {}).fetch("url", nil)
      url = "http://#{url}" unless url.blank? || url.start_with?("http://")

      { "pid" => url,
        "author" => nil,
        "title" => item.deep_fetch('post', 'title') { '' },
        "container-title" => item.deep_fetch('post', 'blog', 'title') { '' },
        "issued" => get_date_parts(timestamp),
        "timestamp" => timestamp,
        "URL" => url,
        "type" => 'post',
        "tracked" => tracked,
        "related_works" => [{ "pid" => work.pid,
                              "source_id" => name,
                              "relation_type_id" => "discusses" }] }
    end
  end

  def config_fields
    [:url]
  end

  def url
    "http://blogs.nature.com/posts.json?doi=%{query_string}"
  end

  def cron_line
    config.cron_line || "* 7 28 * *"
  end

  def rate_limiting
    config.rate_limiting || 5000
  end

  def tracked
    config.tracked || true
  end
end
