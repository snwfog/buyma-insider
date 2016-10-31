require 'active_model_serializers'

class MerchantStatusSerializer < ActiveModel::Serializer
  attributes :total_articles_count,
             :new_articles_count,
             :last_sync_at, # Successful sync
             :merchant
end