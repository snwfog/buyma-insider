require 'nobrainer'

class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :id,             primary_key: true, required: true
  field :description,    type: String, required: true
  field :items_count,    type: Integer, default: 0 # Merchant items crawled
  field :traffic_size,   type: Integer, default: 0 # Traffic used
  field :finished_at,    type: Time
  field :status,         type: Enum, default: :scheduled, in: %i(scheduled inprogress failed success)

  def elapsed_time
    if finished_at.nil?
      -1
    else
      finished_at - created_at
    end
  end
end