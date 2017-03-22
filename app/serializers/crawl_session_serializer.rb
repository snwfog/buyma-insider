class CrawlSessionSerializer < ActiveModel::Serializer
  cache key: :crawl_session, expires_in: 1.day

  attributes :id,
             :started_at,
             :finished_at,
             :items_count,
             :invalid_items_count,
             :traffic_size_kb,
             :elapsed_time_s
end