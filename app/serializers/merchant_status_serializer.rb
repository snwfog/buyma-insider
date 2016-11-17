require 'active_model_serializers'

class MerchantStatusSerializer < ActiveModel::Serializer
  cache key: :merchant_status

  attributes :total_articles_count,
             :new_articles_count,
             :last_sync_at, # Successful sync
             :merchant
end