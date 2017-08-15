class ExtraTariff
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :name,            type:         String,
                          required:     true,
                          unique:       true,
                          index:        true,
                          length:       (1..50)

  field :rate,            type:         Float,
                          required:     true

  field :rate_type,       type:         Enum,
                          in:           [:flat_rate, :percent_rate],
                          default:      :flat

  field :flow_direction,  type:         Enum,
                          in:           [:inflow, :outflow],
                          default:      :in

  field :description,     type:         String,
                          required:     true,
                          length:       (1..500)
end