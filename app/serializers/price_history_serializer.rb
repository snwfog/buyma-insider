require 'active_model_serializers'

class PriceHistorySerializer < ActiveModel::Serializer
  attributes :currency,
             :history

  def history
    object.history.each_pair.map { |k, v| { Time.parse(k).to_i => v } }
  end
end