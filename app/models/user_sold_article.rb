class UserSoldArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,            index:    true,
                               required: true
  belongs_to :article,         index:    true,
                               required: true
  belongs_to :exchange_rate,   index:    true,
                               required: true
  
  has_many :user_sold_article_shipping_services, dependent: :destroy
  has_many :shipping_services, through: :user_sold_article_shipping_services

  index :ix_user_sold_article_user_id_article_id, [:user_id, :article_id]

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

  before_save :set_price, unless: :price

  validates :sold_price, if:           :sold_price,
                         numericality: { greater_than_or_equal_to: 0.0 }
  
  validates_presence_of :shipping_services, if: :shipped_at
  
  def status=(status)
    super
    unless status.to_sym == :confirmed
      self.__send__("#{status}_at=", Time.now.utc.iso8601)
    end
  end
  
  private
  def set_price
    self.price = article.price
  end
end