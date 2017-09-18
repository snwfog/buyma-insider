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

class ArticleSerializer < ActiveModel::Serializer
  cache key: :article, expires_in: 1.day

  # has_one :price_history do
  #   # If this block was present,
  #   # the value of this block will ultimately be
  #   # the association, leaving it commented
  #   # and and include_data config is false, then
  #   # relationship will render as meta: {} only
  #   # see active_model_serializers/adapter/json_api/relationship.rb
  #   include_data true
  # end

  has_many :article_relateds do
    link :related, 'article_relateds'
  end

  belongs_to :merchant do
    include_data true
  end

  attributes :id,
             :name,
             :description,
             :price,
             :link,
             :price_history,
             :min_price,
             :max_price,
             :synced_at,
             :created_at,
             :updated_at

  def name
    object.name.titleize.squish
  end

  def description
    object.description.capitalize
  end

  def synced_at
    object.crawl_histories.last.try(:created_at)
  end

  def price_history
    object.price_histories.map { |price| { timestamp: price.created_at.beginning_of_day,
                                           price:     price.price.to_f } }.uniq
  end

  def price
    object.price.to_f
  end

  def min_price
    object.min_price.to_f
  end

  def max_price
    object.max_price.to_f
  end
end
