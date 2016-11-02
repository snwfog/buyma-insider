require 'nobrainer'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  # after_create do |m|
  # end

  field :id,          primary_key: true, required: true, format: /[a-z]{3}:[\w]+/
  field :name,        type: String, required: true, length: (1..500)
  field :price,       type: Float,  required: true # Latest price
  field :description, type: String, length: (1..1000)
  field :link,        type: String, required: true, length: (1..1000), format: %r(//.*)
  # field :category

  alias_method :unique_id,  :id
  alias_method :sku,        :id
  alias_method :desc,       :description
  alias_method :title,      :name

  # scops
  scope(:new_articles) { where(:created_at.gte => 1.week.ago.utc) }

  class << self
    # @deprecated Factory helper
    # def from_node(html_node)
    #   new(attrs_from_node(html_node))
    # end
    
    def new_articles_expires_in
      7.days
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

  # You should not mess with id...
  # def id=(primary_key)
  #   super("#{self.merchant_code}:#{primary_key}")
  # end

  def name=(name)
    super(name.titleize)
  end

  def link=(link)
    super(link.gsub(%r(^https?://), '//'))
  end
end