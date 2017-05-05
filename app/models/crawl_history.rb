class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer

  belongs_to :index_page,             index: true
  belongs_to :crawl_session,          index: true
  has_many   :crawl_history_articles, dependent: :destroy
  
  field :id,                  primary_key: true
  
  field :status,              type:        Enum,
                              in:          [:scheduled, :inprogress, :aborted, :completed],
                              default:     :scheduled
  
  field :description,         type:        String,
                              required:    true
  
  field :updated_articles_count, type:      Integer,
                                 default:   0
  
  field :created_articles_count, type:      Integer,
                                 default:   0
  
  field :items_count,         type:        Integer,
                              default:     0
  
  field :invalid_items_count, type:        Integer,
                              default:     0
  
  field :traffic_size_kb,     type:        Float,
                              default:     0.0
  
  field :finished_at,         type:        Time
  
  alias_method :started_at, :created_at
  
  default_scope    { order_by(created_at: :desc) }
  scope(:finished) { where(:finished_at.defined => true) }
end