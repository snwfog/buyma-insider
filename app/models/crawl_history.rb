class CrawlHistory
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer

  belongs_to :index_page,             index:     true,
                                      required:  true

  has_many   :crawl_history_articles, dependent: :destroy

  field :id,                     primary_key: true
  field :status,                 type:        Enum,
                                 in:          [:scheduled, :inprogress, :aborted, :completed],
                                 default:     :scheduled

  field :description,            type:        String,
                                 required:    true

  field :created_articles_count, type:        Integer,
                                 default:     0

  field :updated_articles_count, type:        Integer,
                                 default:     0

  field :items_count,            type:        Integer,
                                 default:     0

  field :invalid_items_count,    type:        Integer,
                                 default:     0

  field :traffic_size_kb,        type:        Float,
                                 default:     0.0

  field :response_headers,       type:        Hash
                                 # default:     ->(){{}}
  field :response_code,          type:        Symbol
                                 # in:          Rack::Utils::SYMBOL_TO_STATUS_CODE.keys
  field :finished_at,            type:        Time,
                                 index:       true

  # field :etag,                   type:        String
  # field :last_modified,          type:        Time
  # field :content_encoding,       type:        Enum,
  #                                in:          [:gzip, :deflate, :none],
  #                                default:     :none
  #
  
  alias_method :started_at, :created_at

  default_scope     { order_by(created_at: :desc) }
  scope(:finished)  { where(:finished_at.defined => true).order_by(finished_at: :desc) }
  scope(:completed) { where(status: :completed).order_by(finished_at: :desc) }

  validate :presence_of_response_headers_if_completed
  validate :presence_of_response_code_if_completed

  # validates :response_headers, presence:  true,
  #                              if:        :completed?
  # validates :response_code,    presence:  true,
  #                              inclusion: { in: Rack::Utils::SYMBOL_TO_STATUS_CODE.keys },
  #                              if:        :completed?

  def etag
    response_headers && response_headers[:etag]
  end

  def weak?
    etag && etag.start_with?(?W)
  end

  def last_modified
    response_headers && response_headers[:last_modified]
  end

  def content_encoding
    response_headers && response_headers[:content_encoding]
  end

  def cache_resolve?
    response_code == :not_modified
  end

  private

  def presence_of_response_headers_if_completed
    if completed? && !response_headers
      errors.add(:response_headers, %Q(can't be blank if history is completed))
    end
  end

  def presence_of_response_code_if_completed
    if completed? && !response_code
      errors.add(:response_code, %Q(can't be blank if history is completed))
    end
  end
end
