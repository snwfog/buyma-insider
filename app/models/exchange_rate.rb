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

class ExchangeRate < ActiveRecord::Base
  enum base: [:USD, :CAD, :JYP]

  # default_scope { order(timestamp: :desc) }
  scope :latest, -> { first }

  def timestamp=(unix)
    super Time.at(unix).utc
  end
end
