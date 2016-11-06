require 'active_model_serializers'

class MerchantMetadatumSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :base_url,
             :pager_css,
             :item_css,
             :index_pages,
             :total_articles_count,
             :new_articles_count,
             :last_sync

  def total_articles_count
    object.articles.count
  end

  def new_articles_count
    object.articles.new_articles.count
  end

  def last_sync
    object.crawl_sessions.max(:created_at)
      &.created_at
  end
end