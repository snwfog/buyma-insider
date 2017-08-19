class CrawlHistoryArticle < ActiveRecord::Base
  belongs_to :crawl_history
  belongs_to :article

  enum status: [:created, :updated]
end