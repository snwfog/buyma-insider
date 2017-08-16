ShippingService.seed do |service|
  service.service_name   = 'canada post small package'
  service.rate           = 11.0
  service.weight_in_kg   = 1.0
  service.arrive_in_days = 14
  service.tracked        = false
end

ShippingService.seed do |service|
  service.service_name   = 'canada post medium package'
  service.rate           = 21.0
  service.weight_in_kg   = 2.0
  service.arrive_in_days = 14
  service.tracked        = false
end
