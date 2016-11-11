require 'active_model_serializers'
require 'securerandom'

class ArticleSerializer < ActiveModel::Serializer
  class PriceHistorySerializer < ActiveModel::Serializer
    attributes :currency,
               :history

    def id
      SecureRandom.hex(4)
    end

    def currency
      'USD'
    end

    def history
      object
        .history
        .each_pair
        .map { |k, v| { Time.parse(k).to_i => v } }
    end
  end

  has_one :price_history, serializer: PriceHistorySerializer

  attributes :id,
             :name,
             :price,
             :link,
             :description
end