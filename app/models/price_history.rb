require 'nobrainer'

##
# Models price information and history for an article
#
class PriceHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :article, required: true, unique: true

  field :id,         primary_key: true, required: true
  field :currency,   type: Text, length: (3..3), default: 'CAN'
  field :history,    type: Array, default: -> { [] }

  def add_price_history!(price)
    history << Hash[Time.now.utc.to_s, price]
    save!
  end
end