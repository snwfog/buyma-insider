require 'nobrainer'

class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :id,             primary_key: true, required: true
  field :description,    type: String, required: true
  field :items_count,    type: Integer, default: 0 # Merchant items crawled
  field :traffic_size,   type: Integer, default: 0 # Traffic used
  field :finished_at,    type: Time

  def elapsed_timed
    if finished_at.nil?
      'Unknown'
    else
      finished_at - created_at
    end
  end
end