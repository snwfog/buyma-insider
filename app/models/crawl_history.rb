require 'nobrainer'

class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :crawl_session

  # default_scope { order_by(created_at: :asc) }

  alias_method :started_at, :created_at

  field :id,                  primary_key: true, required: true
  field :crawl_session_id,    type: String, required: true
  field :merchant_id,         type: String, required: true
  field :status,              type: Enum, default: :scheduled, in: %i(scheduled inprogress aborted completed)
  field :link,                type: String, required: true, length: (1..1000), format: %r(//.*)
  field :description,         type: String, required: true
  field :items_count,         type: Integer, default: 0
  field :invalid_items_count, type: Integer, default: 0
  field :traffic_size,        type: Integer, default: 0 # Traffic used
  field :finished_at,         type: Time

  def elapsed_time
    if finished_at.nil?
      -1
    else
      finished_at - created_at
    end
  end

  def completed?
    status == :completed
  end
end