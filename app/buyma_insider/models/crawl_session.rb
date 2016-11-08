require 'nobrainer'

class CrawlSession
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :crawl_histories
  # This association is defined on merchant_metadatum
  # belongs_to :merchant

  field :id, primary_key: true, required: true
  field :merchant_id, type: String, required: true

  validates_presence_of :started_at
  validates_numericality_of :items_count, greater_than_or_equal_to: 0
  validates_numericality_of :invalid_items_count, greater_than_or_equal_to: 0
  validates_numericality_of :traffic_size, greater_than_or_equal_to: 0
  validates_numericality_of :elapsed_time, greater_than_or_equal_to: 0

  def started_at
    # crawl_histories.min_by(&:created_at).created_at
    crawl_histories.min(:created_at)
      &.created_at
  end

  def finished_at
    # crawl_histories.max_by(&:finished_at).finished_at
    crawl_histories.max(:finished_at)
      &.finished_at
  end

  def respond_to_missing?(m, *args)
    case m
    when :items_count,
      :invalid_items_count,
      :traffic_size,
      :elapsed_time
      true
    else
      super
    end
  end

  def method_missing(m, *args)
    case m
    when :items_count,
      :invalid_items_count,
      :traffic_size,
      :elapsed_time
      crawl_histories.map(&m).inject(:+)
    else
      super
    end
  end
end