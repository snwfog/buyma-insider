require 'active_support/descendants_tracker'

class MerchantStatus < AMS::Model
  alias :read_attribute_for_serialization :send

  attr_accessor :new_articles_count
  attr_accessor :total_articles_count
  attr_accessor :last_synced_at

  def self.all
    Merchant::Base.descendants.map { |m_klazz| new(m_klazz) }
  end

  def initialize(m_klazz)
    super()
    @m_klazz = m_klazz
  end

  def new_articles_count
    @m_klazz.article_model.shinchyaku.count
  end

  def total_articles_count
    @m_klazz.article_model.all.count
  end

  def last_sync_at

  end

  def merchant
    @m_klazz.article_model.merchant_code
  end
end