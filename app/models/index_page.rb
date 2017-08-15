class IndexPage < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :index_pages_articles
  
  has_many :crawl_histories, dependent: :destroy
  has_many :index_pages
  
  belongs_to :index_page
  belongs_to :merchant
end