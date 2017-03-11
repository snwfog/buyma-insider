require 'active_model_serializers/serialization_context'

class MerchantSerializer < ActiveModel::Serializer
  has_one :metadatum
  
  # When this is declared, the association is automatically fetched...
  # has_many :articles do
  #   link :test, 'test/lol'
  # end
  
  attributes :name,
             :total_articles_count,
             :last_sync_at
  
  # Proc here, because its called with instance_eval
  link :articles, proc { "merchants/#{object.id}/articles" }
  
  # These methods are here is okay..
  # The question to ask is, do we care about these values on model and backend?
  # If its only for UI display, then serializer is enough
  # If its used for business logic, then should go to the model
  def total_articles_count
    object.articles.count
  end
  
  def last_sync_at
    if session = object.crawl_sessions
                       .where(:finished_at.defined => true).first
      session.finished_at
    end
  end
end