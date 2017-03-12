class CrawlSession
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include Serializable

  has_many    :crawl_histories, scope: -> { order_by(created_at: :desc) }
  
  belongs_to  :merchant, index: true, required: true
  
  alias_method :started_at, :created_at

  field :id,          primary_key: true, required: true
  field :finished_at, type: Time

  default_scope    { order_by(created_at: :desc) }
  scope(:finished) { where(:finished_at.defined => true) }

  [:items_count,
   :invalid_items_count,
   :traffic_size_kb].each do |m|
    define_method(m) { crawl_histories.sum(m) }
  end

  def elapsed_time_s
    finished_at - created_at
  end
end