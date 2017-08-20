# == Schema Information
#
# Table name: shipping_services
#
#  id              :integer          not null, primary key
#  service_name    :string(500)      not null
#  rate            :decimal(12, 5)   not null
#  weight_in_kg    :float            not null
#  arrival_in_days :integer
#  tracked         :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ShippingServiceSerializer < ActiveModel::Serializer
  attributes :service_name,
             :rate,
             :weight_in_kg,
             :arrive_in_days,
             :tracked

  def arrive_in_days
    object.arrival_in_days
  end
end
