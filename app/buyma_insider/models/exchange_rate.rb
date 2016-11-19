require 'nobrainer'

class ExchangeRate
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :id,        primary_key: true, required: true
  field :base,      type: Enum, required: true, in: [:USD, :CAD, :JYP]
  field :timestamp, type: Time, required: true
  field :rates,     type: Hash, required: true

  def self.latest
    order_by(timestamp: :desc).first
  end

  def timestamp=(unix)
    super(Time.at(unix).utc)
  end
end