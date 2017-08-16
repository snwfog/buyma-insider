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
end
