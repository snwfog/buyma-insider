require 'nobrainer'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  after_find do |m|
    m.new_article = false
  end

  attr_accessor :new_article

  field :id,          primary_key: true, required: true
  field :name,        type: String, required: true, length: (1..500)
  field :price,       type: Float,  required: true # Latest price
  field :description, type: String, length: (1..1000)
  field :link,        type: String, required: true, length: (1..1000), format: %r(//.*)
  # field :category

  alias_method :unique_id,  :id
  alias_method :sku,        :id
  alias_method :desc,       :description
  alias_method :title,      :name

  class_attribute :merchant_code # 3 letters code to make id unique

  class << self
    def attrs_from_node(n); raise 'Not implemented'; end
    # Factory helper
    def from_node(html_node)
      new(attrs_from_node(html_node))
    end
  end

  def price=(price)
    super(price)
    NoBrainer::Lock.new("price_history:price=:#{self.id}").synchronize do
      price_history = PriceHistory.upsert(article_id: self.id)
      price_history.add_price(price)
      price_history.save
    end
  end

  def name=(name)
    super(name.titleize)
  end

  def link=(link)
    super(link.gsub(%r(^https?://), '//'))
  end

  def new_article?
    new_article.nil? ? true : new_article
  end
end
