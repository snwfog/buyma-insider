# == Schema Information
#
# Table name: index_pages
#
#  id            :integer          not null, primary key
#  merchant_id   :integer          not null
#  index_page_id :integer
#  relative_path :string(2000)     not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class IndexPage < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :index_pages_articles
  
  has_many :crawl_histories, dependent: :destroy
  has_many :index_pages, dependent: :destroy

  belongs_to :merchant
  belongs_to :index_page
end
