class ShippingServiceSerializer < ActiveModel::Serializer
  attributes :service_name,
             :rate,
             :weight_in_kg,
             :arrive_in_days,
             :tracked
end