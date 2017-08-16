# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  merchant_id :integer          not null
#  sku         :string(100)      not null
#  name        :string(500)      not null
#  description :text
#  link        :string(2000)     not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Article < ActiveRecord::Base
  EXPIRES_IN = 1.week

  has_many :user_article_solds, dependent: :destroy
  has_many :user_article_watcheds, dependent: :destroy
  has_many :crawl_history_articles, dependent: :destroy
  has_many :price_histories, -> { order(created_at: :desc) }, dependent: :destroy

  belongs_to :merchant

  def price=()
    raise
  end

  def price
    if price_histories
      price_histories.first
    end
  end
end
