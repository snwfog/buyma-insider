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
#  image_link  :string(2000)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Article < ActiveRecord::Base
  has_and_belongs_to_many :crawl_histories, join_table: :crawl_histories_articles, dependent: :destroy

  has_many :user_article_solds, dependent: :destroy
  has_many :user_article_watcheds, dependent: :destroy
  has_many :price_histories, dependent: :destroy, autosave: true

  belongs_to :merchant, touch: true

  validates_length_of :sku, within: (1..100)
  validates_length_of :name, within: (1..500)
  validates_length_of :description, within: (1..2000)

  validates :link, article_url: true

  def price=(price)
    @price = price_histories.build(price: price)
  end

  def price
    @price ||= price_histories.latest.try(:price)
  end

  def max_price
    price_histories.max.try(:price)
  end

  def min_price
    price_histories.min.try(:price)
  end

  def link=(link)
    super link.gsub(%r{^https?://}, '//')
  end
end
