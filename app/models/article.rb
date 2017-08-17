# == Schema Information
#
# Table name: articles
#
#  id           :integer          not null, primary key
#  merchant_id  :integer          not null
#  merchant_sku :string(100)      not null
#  sku          :string(100)      not null
#  name         :string(500)      not null
#  description  :text
#  link         :string(2000)     not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Article < ActiveRecord::Base
  EXPIRES_IN = 1.week

  # has_and_belongs_to_many :crawl_histories, join_table: :crawl_histories_articles, dependent: :destroy

  has_many :user_article_solds, dependent: :destroy
  has_many :user_article_watcheds, dependent: :destroy
  has_many :price_histories, dependent: :destroy

  belongs_to :merchant

  after_save :create_price_history, if: :price

  def create_price_history
    price_histories.create(article: self, price: price)
  end

  def price=(price)
    @price = price
  end

  def price
    @price || price_histories.first&.price
  end

  def max_price
    price_histories.order(price: :desc)&.price
  end

  def min_price
    price_histories.order(price: :asc)&.price
  end

  def name=(name)
    super(name.titleize)
  end

  def link=(link)
    super(link.gsub(%r{^https?://}, '//'))
  end
end

