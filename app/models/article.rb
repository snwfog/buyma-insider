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
  EXPIRES_IN                      = 1.week
  SIMPLE_URL_LINK_VALIDATOR_REGEX = %r{\A//(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)\z}

  has_and_belongs_to_many :crawl_histories, join_table: :crawl_histories_articles, dependent: :destroy

  has_many :user_article_solds, dependent: :destroy
  has_many :user_article_watcheds, dependent: :destroy
  has_many :price_histories, dependent: :destroy

  belongs_to :merchant

  after_save :create_price_history, if: :price

  validates_length_of :sku, within: (1..100)
  validates_length_of :name, within: (1..500)
  validates_length_of :description, within: (1..2000)
  validates_format_of :link, with: SIMPLE_URL_LINK_VALIDATOR_REGEX

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
    price_histories.order(price: :desc).first&.price
  end

  def min_price
    price_histories.order(price: :asc).first&.price
  end

  def name=(name)
    super(name.titleize)
  end

  def link=(link)
    super(link.gsub(%r{^https?://}, '//'))
  end
end
