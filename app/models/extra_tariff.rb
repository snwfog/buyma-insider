class ExtraTariff
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :name,            type:         String,
                          required:     true,
                          unique:       true,
                          length:       (1..50)
  field :rate,            type:         Float,
                          required:     true
  field :flat_or_percent, type:         Enum,
                          in:           [:flat, :percent],
                          default:      :flat
  field :in_or_out_flow,  type:         Enum,
                          in:           [:in, :out],
                          default:      :in
  field :description,     type:         String,
                          required:     true,
                          length:       (1..500)
end