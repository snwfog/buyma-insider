require 'nobrainer'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  after_create do |m|
    $redis.with do |conn|
      conn.pipelined do
        conn.zadd(:'articles:new:expires_at', new_articles_expires_at.from_now.utc.to_i, m.id)
        conn.hincrby(:'articles:new:summary', merchant_code, 1)
      end
    end
  end

  attr_accessor :new_article
  attr_accessor :new_article_expires_at

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

  class_attribute :merchant_code # 3 letters code to make id unique
  class_attribute :new_articles_expires_at

  # scops
  scope(:new_articles) { where(:created_at.gte => 1.week.ago.utc) }

  class << self
    def attrs_from_node(n); raise 'Not implemented'; end

    # Factory helper
    def from_node(html_node)
      new(attrs_from_node(html_node))
    end

    # TODO: Deprecate this
    def new_articles_expires_at
      @new_articles_expires_at || 7.days
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
