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

class ExchangeRate < ActiveRecord::Base
  enum :base, [:usd, :cad, :jyp]

  default_scope { order(timestamp: :desc) }
  scope :latest, -> { first }

  def timestamp=(unix)
    super(Time.at(unix).utc)
  end

  def rates=(rates_h)
    super YAML.dump(rates_h) unless rates_h.blank?
  end

  def rates
    rates_yaml = super
    @rates  = rates_yaml.blank? ? nil : YAML.load(rates_yaml)
  end
end
