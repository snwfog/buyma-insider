class ExchangeRate
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer

  field :id,        primary_key: true
  
  field :base,      type:     Enum,
                    required: true,
                    in:       [:USD, :CAD, :JYP]
  
  field :timestamp, type:     Time,
                    required: true
  
  field :rates,     type:     Hash,
                    required: true

  default_scope { order_by(created_at: :desc) }

  def self.latest
    first
  end

  def timestamp=(unix)
    super(Time.at(unix).utc)
  end
end