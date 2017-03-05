require 'nobrainer'

class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :crawl_session
  
  belongs_to :merchant
  
  # default_scope { order_by(created_at: :asc) }

  alias_method :started_at, :created_at

  field :id,                  primary_key: true, required: true
  field :status,              type: Enum, default: :scheduled, in: %i(scheduled inprogress aborted completed)
  field :link,                type: String, required: true, length: (1..1000), format: %r(//.*)
  field :description,         type: String, required: true
  field :items_count,         type: Integer, default: 0
  field :invalid_items_count, type: Integer, default: 0
  field :traffic_size_kb,     type: Integer, default: 0 # Traffic used
  field :finished_at,         type: Time
  
  default_scope { order_by(created_at: :desc) }

  def elapsed_time_s
    ended_at = inprogress? ? Time.now.utc : finished_at
    ended_at - started_at
  end
end