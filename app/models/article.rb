require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/string/inflections'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include ElasticsearchSync
  include CacheableSerializer

  EXPIRES_IN = 1.week

  belongs_to :merchant,             index:    true,
                                    required: true
  has_many :user_article_watcheds,  dependent: :destroy
  has_many :user_article_solds,     dependent: :destroy
  has_many :crawl_history_articles, dependent: :destroy
  has_one  :price_history,          dependent: :destroy
  

  field :id,          primary_key: true,
                      required:    true, # merchant_id + ':' + sku
                      format:      /[a-z]{3}:[a-z0-9]+/
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
  
  # around_save  :watch_for_price_updates, unless: :new_record?
  after_create  :create_price_history!,        unless: :price_history

  alias_method :desc,       :description
  alias_method :title,      :name

  scope(:latests)          { where(:created_at.gte => EXPIRES_IN.ago.utc) }
  
  delegate :on_sale?, to: :price_history

  # def watch_for_price_updates
  #   changes = self.changes
  #   yield
  #
  #   if changes.key?(:price)
  #     old_value, new_value = changes.fetch(:price)
  #     # No need to load DB, just delegate to the job
  #     # to load the watched users
  #     UserArticleWatchedWorker.perform_async(id)
  #     NoBrainer.logger.info {
  #       '`%s` got %s at %.02f' % [self.name,
  #                                 new_value > old_value ? 'expensive' : 'cheaper',
  #                                 new_value] }
  #   end
  # end
  
  def update_price_history!
    price_history.add_price_history!(price)
    save!
  end

  # You should not mess with id...
  # def id=(primary_key)
  #   super("#{self.merchant_code}:#{primary_key}")
  # end

  def name=(name)
    super(name.titleize)
  end
  
  def price=(price)
    super(price.to_f)
  end

  def link=(link)
    super(link.gsub(%r{^https?://}, '//'))
  end
  
  def new?
    (created_at + EXPIRES_IN) > Time.now.utc
  end
  
  private
  def create_price_history!
    PriceHistory.create!(article: self) and reload
  end
end
