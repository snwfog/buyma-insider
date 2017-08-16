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
  default_scope { order(timestamp: :desc) }
  scope :latest, -> { first }

  def timestamp=(unix)
    super(Time.at(unix).utc)
  end
end
