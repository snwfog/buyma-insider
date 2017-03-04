require 'nobrainer'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  EXPIRES_IN = 1.week

  has_one :price_history
  
  belongs_to :merchant_metadatum, required: true

  after_save do |article|
    price_history ||= PriceHistory.create!(article)
  end
  
  after_create do |article|
    price_history = PriceHistory.new(article)
  end

  after_destroy do |article|
  end

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

  # scopes
  ## New articles
  scope(:latests) { where(:created_at.gte => EXPIRES_IN.ago.utc) }
  # TODO: To implement
  ## On sale articles
  scope(:sales)    { where(:price.lt => 1.00) }
  
  def merchant=(merchant)
    merchant_metadatum = merchant.metadatum
  end

  def price=(price)
    super(price.to_f)
    price_history.add_price(price)
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

  def new?
    (created_at + EXPIRES_IN) > Time.now.utc
  end
end
