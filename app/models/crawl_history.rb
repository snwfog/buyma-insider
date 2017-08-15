class CrawlHistory < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :crawl_histories_articles
  
  belongs_to :index_page
end