# == Schema Information
#
# Table name: merchants
#
#  id         :integer          not null, primary key
#  code       :string(3)        not null
#  name       :string(500)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MerchantSerializer < ActiveModel::Serializer
  cache key: :merchant, expires_in: 1.day

  has_many :articles do
    link :related, proc { 'articles' }
  end

  has_many :index_pages do
    include_data(true)
  end

  has_one :merchant_metadatum do
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

  def id
    object.code
  end

  def name
    object.name.titleize
  end

  # These methods are here is okay..
  # The question to ask is, do we care about these values on model and backend?
  # If its only for UI display, then serializer is enough
  # If its used for business logic, then should go to the model
  def total_articles_count
    object.articles.count
  end

  def last_synced_at
    nil
  end
end
