class CrawlSessionArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :crawl_session, index:    true,
                             required: true
  belongs_to :article,       index:    true,
                             required: true
  
  field :article_id,         unique: { scope: :crawl_session_id }
  
  index :ix_crawl_session_article_crawl_session_id_article_id,
        [:crawl_session_id, :article_id]
end