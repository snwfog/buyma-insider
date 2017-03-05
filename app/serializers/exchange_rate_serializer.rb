require 'active_model_serializers'

class ExchangeRateSerializer < ActiveModel::Serializer
  DEFAULT_RATES = %w(JPY CAD USD)

  # cache key: :exchange_rates
  attributes :id,
             :base,
             :timestamp,
             :rates

  def rates
    object.rates.select { |k, v| DEFAULT_RATES.include? k }
  end
end