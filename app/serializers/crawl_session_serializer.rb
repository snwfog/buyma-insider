require 'active_model_serializers'

class CrawlSessionSerializer < ActiveModel::Serializer
  # cache key: :crawl_session

  attributes :id,
             :started_at,
             :finished_at,
             :items_count,
             :invalid_items_count,
             :traffic_size_kb,
             :elapsed_time_s
end