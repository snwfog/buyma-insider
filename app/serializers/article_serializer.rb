require 'active_model_serializers'
require 'securerandom'

class ArticleSerializer < ActiveModel::Serializer
  has_one :price_history

  attributes :id,
             :name,
             :price,
             :link,
             :description

  class PriceHistorySerializer < ActiveModel::Serializer
    attributes :currency,
               :history

    def id
      object.article_id
    end

    def history
      object
        .history
        .each_pair
        .map { |date, price| [date: date, price: price] }
    end
  end
end