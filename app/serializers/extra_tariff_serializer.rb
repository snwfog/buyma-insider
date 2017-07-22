class ExtraTariffSerializer < ActiveModel::Serializer
  # cache key: :extra_tariffs
  attributes :id,
             :name,
             :rate,
             :rate_type,
             :flow_direction,
             :description
end