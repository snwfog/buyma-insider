require 'active_model_serializers'
require 'securerandom'

class ArticleSerializer < ActiveModel::Serializer
  # has_one :price_history

  # cache key: :article

  attributes :id,
             :name,
             :description,
             :price,
             :link,
             :price_history,
             # :price_summary,
             :created_at,
             :updated_at

  def price_history
    object.price_history.history
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
