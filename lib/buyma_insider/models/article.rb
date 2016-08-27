require 'nobrainer'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  field :id, primary_key: true
  field :sku
  field :name
  field :description
  field :link
  # field :category
end
