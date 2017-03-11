require 'active_model_serializers'

class MerchantMetadatumSerializer < ActiveModel::Serializer
  # cache key: :merchant_metadatum

  attributes :id,
             :name,
             :base_url,
             :pager_css,
             :item_css,
             :index_pages,
             :ssl
  
             # :new_articles_count,
             # :last_sync_at

  # def new_articles_count
  #   # This is a chained criteria, not method call
  #   object.shinchyaku.count
  # end

end