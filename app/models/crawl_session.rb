require 'nobrainer'

class CrawlSession
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many    :crawl_histories, scope: -> { order_by(created_at: :asc).limit(20) }
  
  belongs_to  :merchant, required: true
  
  alias_method :started_at, :created_at

  field :id,          primary_key: true, required: true
  field :finished_at, type: Time
  
  default_scope { order_by(created_at: :desc) }

  # INFO: Disable validation for now
  # validates_presence_of :started_at
  # validates_numericality_of :items_count, greater_than_or_equal_to: 0
  # validates_numericality_of :invalid_items_count, greater_than_or_equal_to: 0
  # validates_numericality_of :traffic_size, greater_than_or_equal_to: 0
  # validates_numericality_of :elapsed_time, greater_than_or_equal_to: 0

  # def started_at
  #   # crawl_histories.min_by(&:created_at).created_at
  #   crawl_histories.min(:created_at)
  #     &.created_at
  # end

  [:items_count,
   :invalid_items_count,
   :traffic_size_kb,
   :elapsed_time_s]
  .each do |m|
    define_method(m) do
      crawl_histories.map(&m).inject(0, :+)
    end
  end
end