require 'active_model_serializers'

class CrawlHistorySerializer < ActiveModel::Serializer
  cache key: :crawl_history

  attributes :id,
             :status,
             # :link,
             :description,
             :items_count,
             :invalid_items_count,
             :traffic_size,
             :finished_at,
             :created_at,
             :updated_at
end