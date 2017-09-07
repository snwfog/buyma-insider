# == Schema Information
#
# Table name: extra_tariffs
#
#  id             :integer          not null, primary key
#  tariff_name    :string(500)      not null
#  rate           :decimal(12, 5)   not null
#  rate_type      :integer          not null
#  flow_direction :integer          not null
#  description    :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class ExtraTariffSerializer < ActiveModel::Serializer
  cache key: :extra_tariffs, expires_in: 1.week
  
  attributes :id,
             :name,
             :rate,
             :rate_type,
             :flow_direction,
             :description

  def name
    object.tariff_name
  end
end
