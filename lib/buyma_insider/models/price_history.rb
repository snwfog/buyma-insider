require 'nobrainer'

##
# Models price information and history for an article
#
class PriceHistory
  include NoBrainer::Document

  field :article_id,  primary_key: true
  field :currency,    type: Text, length: (3..3), default: 'CAN'
  field :history,     type: Hash, default: {}

  def add_price(price)
    history[Time.now.utc.to_i.to_s] = price
  end
end