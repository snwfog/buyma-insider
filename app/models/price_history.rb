##
# Models price information and history for an article
#
class PriceHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer
  
  belongs_to :article, foreign_key: :article_id

  field :article_id, primary_key: true,
                     required:    true
  
  field :currency,   type:    Text,
                     length:  (3..3),
                     default: 'CAN'
  
  field :history,    type:    Array,
                     default: -> { [] }
  
  field :max_price,  type:    Float,
                     default: Float::MIN
  
  field :min_price,  type:    Float,
                     default: Float::MAX
  
  field :avg_price,  type:    Float,
                     default: 0.0
  
  # around_save :calculate_price_stats, unless: :new_record?
  #
  # def calculate_price_stats
  #   changes = self.changes
  #
  #   yield
  #
  #   changes.each do |attr, (old_value, new_value)|
  #     next unless old_value
  #     case attr.to_sym
  #     when :max_price
  #       if old_value != Float::MIN
  #         NoBrainer.logger.info {
  #           '`%s` got expensive at %.02f' % [ article.name, current_price ] }
  #       end
  #     when :min_price
  #       if old_value != Float::MAX
  #         NoBrainer.logger.info {
  #           '`%s` got cheaper at %.02f' % [ article.name, current_price ] }
  #       end
  #     end
  #   end
  # end
  
  def current_price
    history.last&.fetch(:price) || 0.00
  end

  def add_price_history!(price)
    self.max_price = [max_price, price].max
    self.min_price = [min_price, price].min
    self.avg_price = (current_price + price) / 2
    history << Hash[:timestamp, Time.now.utc.iso8601, :price, price]
    save!
  end
end