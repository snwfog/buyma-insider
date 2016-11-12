require 'active_model_serializers'
require 'securerandom'

class ArticleSerializer < ActiveModel::Serializer
  # has_one :price_history

  attributes :id,
             :name,
             :price,
             :link,
             :price_history,
             :description

  def price_history
    object.price_history.history
  end

  # class PriceHistorySerializer < ActiveModel::Serializer
  #   attributes :currency,
  #              :history
  #
  #   def id
  #     object.article_id
  #   end
  #
  #   def history
  #     object
  #       .history
  #       .each_pair
  #       .map { |date, price| [created_at: date, price: price] }
  #   end
  # end
end