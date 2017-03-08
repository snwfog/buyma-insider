require 'nobrainer'

class CrawlSession
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many    :crawl_histories, scope: -> { order_by(created_at: :desc) }
  
  belongs_to  :merchant, required: true
  
  alias_method :started_at, :created_at

  field :id,          primary_key: true, required: true
  field :finished_at, type: Time

  
  default_scope { order_by(created_at: :desc) }

  [:items_count, :invalid_items_count, :traffic_size_kb].each do |m|
    define_method(m) { crawl_histories.sum(m) }
  end

  def elapsed_time_s
    crawl_histories.where(status: :completed)
                   .sum { |h| h['finished_at'] - h['created_at'] }
  end
end