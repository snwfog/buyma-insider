require 'active_model_serializers'

class MerchantMetadatumSerializer < ActiveModel::Serializer
  cache key: :merchant_metadatum

  attributes :id,
             :name,
             :base_url,
             :pager_css,
             :item_css,
             :index_pages,
             :total_articles_count,
             # :new_articles_count,
             :last_sync_at

  def total_articles_count
    object.articles.count
  end

  # def new_articles_count
  #   # This is a chained criteria, not method call
  #   object.shinchyaku.count
  # end

  def last_sync_at
    object.crawl_sessions.max(:created_at)&.created_at
  end
end