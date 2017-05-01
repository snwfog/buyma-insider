class ShippingService
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  field :service_name,   type:     String,
                         required: true,
                         unique:   true,
                         length:   (1..500)
  field :rate,           type:     Float,
                         required: true
  field :weight_in_kg,   type:     Float,
                         required: true
  field :arrive_in_days, type:     Integer,
                         required: true
  field :tracked,        type:     Boolean,
                         required: true,
                         default:  false
end