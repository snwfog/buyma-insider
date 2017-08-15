class IndexPage
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  include CacheableSerializer
  
  has_many   :crawl_histories, dependent: :destroy
  has_many   :index_pages,     dependent: :destroy

  belongs_to :index_page,      index:      true

  # has_many   :articles, through: :index_page_articles
  
  belongs_to :merchant, index:       true,
                        required:    true
  
  field :id,            primary_key: true
  
  field :relative_path, type:        String,
                        required:    true,
                        index:       true,
                        unique:      true,
                        length:      (1..1000)

  # field :root,          type:        Boolean,
  #                       required:    true,
  #                       default:     false

  scope(:root_index_pages) { where(:index_page_id.undefined => true) }

  def full_url
    domain = merchant.metadatum.domain
    scheme << ':' << domain << relative_path
  end

  def scheme
    merchant.metadatum.ssl? ? 'https' : 'http'
  end

  def cache_filename
    relative_path.tr('\\/:*?"<>|.', ?_)
  end

  def cache_html_path
    File.expand_path('%<app_path>s/tmp/cache/crawl/%<merchant_id>s/%<cache_filename>s' % {
      root:           BuymaInsider.root,
      merchant_id:    merchant_id,
      cache_filename: cache_filename
    })
  end

  # Its always the latest and we assume
  # there can be only 1 of them at the cache location
  def cache_html_document
    if File.exists?(cache_html_path)
      content_encoding           = crawl_histories.completed.first
                                     &.content_encoding || 'gzip'.freeze
      cache_html_encoded_content = File.open(cache_html_path, 'rb') { |file| file.read }
      @cache_html_document       ||= RestClient::Request.decode(content_encoding, cache_html_encoded_content)
    else
      nil
    end
  end

  def to_s
    full_url
  end
end