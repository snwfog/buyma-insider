class Tariff
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  field :name,   type:     String,
                 required: true,
                 unique:   true,
                 length:   (1..50)
  field :amount, type:     Float,
                 required: true,
                 default:  0.0
  field :flow,   type:     Enum,
                 required: true,
                 in:       [:income, :expenditure],
                 default:  :expenditure
end