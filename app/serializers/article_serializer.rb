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

class ArticleSerializer < ActiveModel::Serializer
  cache key: :article, expires_in: 24.hours

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


  attributes :id,
             :name,
             :description,
             :price,
             :link,
             :price_history,
             # :price_summary,
             :min_price,
             :max_price,
             :synced_at,
             :created_at,
             :updated_at

  def synced_at
    object
      .crawl_histories
      .completed
      .take
      &.created_at
  end

  def price_history
    object.price_histories.map do |price_history|
      Hash[:timestamp, price_history.created_at, :price, price_history.price.to_f]
    end
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

  # def price_summary
  #   histories = object.price_history.history
  #   stats     = Hash.new
  #   unless histories.empty?
  #     min, max    = histories.minmax
  #     stats[:max] = { seen_at: max.first, price: max.last.to_f }
  #     stats[:min] = { seen_at: min.first, price: min.last.to_f }
  #     stats[:avg] = { price: histories.values.inject(0.0, :+) / histories.count }
  #   end
  #   stats
  # end
end
