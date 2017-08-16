ExtraTariff.seed do |et|
  et.tariff_name    = 'canada import duty'
  et.rate           = 15.0
  et.rate_type      = :percent_rate
  et.flow_direction = :inflow
  et.description    = 'Canada import duty, applied on sold articles'
end