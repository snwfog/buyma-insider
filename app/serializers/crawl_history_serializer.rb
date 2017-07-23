class CrawlHistorySerializer < ActiveModel::Serializer
  # cache key: :crawl_history

  attributes :id,
             :status,
             # :link,
             :description,
             :created_articles_count,
             :updated_articles_count,
             :items_count,
             :invalid_items_count,
             :traffic_size_kb,
             :response_headers,
             :response_code,
             :finished_at,
             :created_at,
             :updated_at
end