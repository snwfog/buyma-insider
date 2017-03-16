##
# Models price information and history for an article
#
class PriceHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer
  
  belongs_to :article, index: true,
                       required: true,
                       unique: true

  field :currency,   type: Text, length: (3..3), default: 'CAN'
  field :history,    type: Array, default: -> { [] }

  def add_price_history!(price)
    history << Hash[:timestamp, Time.now.utc.iso8601, :price, price]
    save!
  end
end