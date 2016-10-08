require 'nobrainer'

class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :id,             primary_key: true, required: true
  field :description,    type: String, required: true
  field :merchant_items, type: Integer # Merchant items crawled
  field :traffic,        type: Integer # Traffic used
  field :finished_at,    type: Time
end