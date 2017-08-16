# == Schema Information
#
# Table name: exchange_rates
#
#  id         :integer          not null, primary key
#  base       :string(3)        not null
#  timestamp  :datetime         not null
#  rates      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
