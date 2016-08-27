require 'nobrainer'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  field :id,          primary_key: true
  field :name,        type: String, required: true, length: (1..500)
  field :price,       type: Float,  required: true # Latest price
  field :description, type: String, length: (1..1000)
  field :link,        type: String, required: true, length: (1..1000), format: %r(https?://)
  # field :category

  attr_reader :unique_id

  class << self
    def from_node; raise 'Not implemented'; end
    # def primary_key(primary_key_name = :id)
    #   @primary_key ||= primary_key_name
    # end
  end

  def price=(price)
    super(price)
    price_history ||= PriceHistory.new
    price_history.add_price(price)
  end

  # def id
  #   self.send(self.class.primary_key)
  # end
end
