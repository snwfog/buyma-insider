class UserArticleSold
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many   :user_article_sold_extra_tariff,      dependent: :destroy
  has_many   :extra_tariff,                        through: :user_article_sold_extra_tariff
  has_many   :user_article_sold_shipping_services, dependent: :destroy
  has_many   :shipping_services,                   through: :user_article_sold_shipping_services

  has_one    :user_article_sold_buyer, dependent: :destroy
  has_one    :buyer,                   through: :user_article_sold_buyer

  belongs_to :user,            index:    true,
                               required: true
  belongs_to :article,         index:    true,
                               required: true
  belongs_to :exchange_rate,   index:    true,
                               required: true
  
  index :ix_user_article_sold_user_id_article_id, [:user_id, :article_id]

  alias_method :sold_at,       :created_at
  alias_method :confirmed_at,  :created_at

  STATUS = [:confirmed,
            :shipped,
            :cancelled,
            :received,
            :returned]
  
  field :status,     type:    Enum,
                     in:      STATUS,
                     default: :confirmed
  
  # State cycle for a sold article update status and timestamp
  (STATUS - [:confirmed]).each do |state|
    field :"#{state}_at", type: Time
    define_method("#{state}!") do
      super() and self.__send__("#{state}_at=", Time.now)
    end
  end

  field :price,      type:    Float
  field :sold_price, type:    Float
  # field :sold_currency, type:    Enum,
  #                       in:      [:cad, :jpy]

  before_save   :set_price, unless: :price
  
  # This is called after ids=() assignment is called
  # Making it useless
  # before_update :destroy_all_user_article_sold_shipping_services
  # before_save :destroy_all_user_article_sold_shipping_services
  after_save :upsert_user_article_sold_shipping_services

  validates :sold_price, if:           :sold_price,
                         numericality: { greater_than_or_equal_to: 0.0 }
  
  validates_presence_of :shipping_services, if: :shipped_at
  
  def status=(status)
    super
    unless status.to_sym == :confirmed
      self.__send__("#{status}_at=", Time.now.utc.iso8601)
    end
  end

  attr_accessor :shipping_service_ids
  # def shipping_service_ids=(shipping_service_ids)
  #   @shipping_service_ids = shipping_service_ids
  # end

  private
  def set_price
    self.price = article.price
  end
  
  def upsert_user_article_sold_shipping_services
    if shipping_service_ids&.any?
      user_article_sold_shipping_services.destroy_all
      ShippingService.where(:id.in => shipping_service_ids).each do |shipping_service|
        UserArticleSoldShippingService.upsert!(user_article_sold: self,
                                               shipping_service:  shipping_service)
      end
    end
    # Calling this mess up the update process
    # It rollsback everything, so do not call `#reload`
    # reload
  end
  
  def destroy_all_user_article_sold_shipping_services
    user_article_sold_shipping_services.destroy_all
  end
end