# == Schema Information
#
# Table name: exchange_rates
#
#  id         :integer          not null, primary key
#  base       :integer          not null
#  timestamp  :datetime         not null
#  rates      :hstore           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExchangeRateSerializer < ActiveModel::Serializer
  DEFAULT_RATES = %w(JPY CAD USD)

  cache key: :exchange_rates, expires_in: 1.week
  
  attributes :id,
             :base,
             :timestamp,
             :rates

  def rates
    object.rates.select do |currency, _rate|
      DEFAULT_RATES.include?(currency)
    end
  end
end
