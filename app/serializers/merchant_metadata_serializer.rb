require 'active_model_serializers'

class MerchantMetadataSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :base_url,
             :pager_css,
             :item_css,
             :index_pages
end