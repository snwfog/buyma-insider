class CrawlHistoryArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :crawl_history, index:    true,
                             required: true
  belongs_to :article,       index:    true,
                             required: true
  
  field :article_id,         unique:   { scope: :crawl_history_id }
  field :status,             type:     Enum,
                             required: true,
                             in:       [:created, :updated]
  
  index :ix_crawl_history_articles_crawl_history_id_article_id,
        [:crawl_history_id, :article_id]

  default_scope { order_by(created_at: :desc) }
end