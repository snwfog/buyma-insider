require 'nobrainer'

class Article
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_one :price_history

  field :id,          primary_key: true, required: true
  field :name,        type: String, required: true, length: (1..500)
  field :price,       type: Float,  required: true # Latest price
  field :description, type: String, length: (1..1000)
  field :link,        type: String, required: true, length: (1..1000), format: %r(https?://)
  # field :category

  attr_reader :unique_id

  class << self
    def attrs_from_node(n); raise 'Not implemented'; end
    def from_node(n); raise 'Not implemented'; end
    # def primary_key(primary_key_name = :id)
    #   @primary_key ||= primary_key_name
    # end
  end

  def price=(price)
    super(price)
    NoBrainer::Lock.new("price_history:price=:#{self.id}").synchronize do
      price_history = PriceHistory.upsert(article_id: self.id)
      price_history.add_price(price)
      price_history.save
    end
  end

  # def id
  #   self.send(self.class.primary_key)
  # end
end
