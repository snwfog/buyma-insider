require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include ElasticsearchSynceable
  include CacheableSerializer

  EXPIRES_IN = 1.week
  
  has_many :user_watched_articles, dependent: :destroy
  
  has_many :user_sold_articles,    dependent: :destroy

  has_one :price_history,          dependent: :destroy
  
  belongs_to :merchant, index:    true,
                        required: true

  field :id,          primary_key: true,
                      required:    true # merchant_id:sku
  
  field :sku,         type:        String,
                      required:    true,
                      length:      (1..100)
  
  field :name,        type:        String,
                      required:    true,
                      length:      (1..500)
  
  field :price,       type:        Float,
                      required:    true # Latest price
  
  field :description, type:        String,
                      length:      (1..1000)
  
  field :link,        type:        String,
                      required:    true,
                      length:      (1..1000),
                      format:      %r{//.+}
  
  around_save :watch_for_price_updates, unless: :new_record?
  
  alias_method :desc,       :description
  alias_method :title,      :name

  scope(:latests)          { where(:created_at.gte => EXPIRES_IN.ago.utc) }
  # TODO: To implement
  scope(:sales)            { where(:price.lt => 1.00) }

  def watch_for_price_updates
    changes = self.changes
    yield
  
    if changes.key?(:price)
      old_value, new_value = changes.fetch(:price)
      NoBrainer.logger.info {
        '`%s` got %s at %.02f' % [self.name,
                                  new_value > old_value ? 'expensive' : 'cheaper',
                                  new_value] }
    end
  end
  
  def update_price_history!
    price_history ||= PriceHistory.upsert!(article: self)
    price_history.add_price_history!(price)
  end

  # You should not mess with id...
  # def id=(primary_key)
  #   super("#{self.merchant_code}:#{primary_key}")
  # end

  def name=(name)
    super(name.titleize)
  end

  def link=(link)
    super(link.gsub(%r{^https?://}, '//'))
  end

  def new?
    (created_at + EXPIRES_IN) > Time.now.utc
  end
end
