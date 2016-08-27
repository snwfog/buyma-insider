require 'nobrainer'

##
# Models price information and history for an article
#
class PriceHistory
  include NoBrainer::Document
  # belongs_to :article

  field :article_id,  primary_key: true
  field :currency,    default: 'CAN'
  field :prices,      type: Hash, default: {}
end