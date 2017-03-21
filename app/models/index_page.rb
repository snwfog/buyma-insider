class IndexPage
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  has_many   :crawl_histories, dependent: :destroy
  
  # has_many   :articles, through: :index_page_articles
  
  belongs_to :merchant, index:       true,
                        required:    true
  
  field :id,            primary_key: true
  
  field :relative_path, type:        String,
                        required:    true,
                        uniq:        true,
                        length:      (1..1000)

  def full_url
    protocol = merchant.metadatum.ssl? ? 'https' : 'http'
    domain   = merchant.metadatum.domain
  
    protocol << ':' << domain << '/' << relative_path
  end

  
  def to_s
    full_url
  end
end