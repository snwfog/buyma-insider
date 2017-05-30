require 'active_model_serializers/serialization_context'

class MerchantSerializer < ActiveModel::Serializer
  cache key: :merchant, expires_in: 5.minutes

  has_many :articles do
    link :related, proc { 'articles' }
  end
  
  has_many :crawl_sessions do
    link :related, proc { 'crawl_sessions' }
  end
  
  has_many :index_pages do
    include_data(true)
  end
  
  has_one :metadatum do
    include_data(true)
    # Disable link if it is not an async relationship
    # link :related, proc { "/merchants/#{object.id}/metadatum" }
  end
  
  
  # When this is declared, the association is automatically fetched...
  # has_many :articles do
  #   link :test, 'test/lol'
  # end
  
  attributes :name,
             :total_articles_count,
             :last_synced_at
  
  # These methods are here is okay..
  # The question to ask is, do we care about these values on model and backend?
  # If its only for UI display, then serializer is enough
  # If its used for business logic, then should go to the model
  def total_articles_count
    object.articles.count
  end
  
  def last_synced_at
    if session = object.crawl_sessions&.finished&.first
      session.finished_at
    end
  end
end