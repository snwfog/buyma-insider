redis_pool = BuymaInsider.redis_for(:sidekiq)

Sidekiq.configure_server do |cfg|
  cfg.redis = redis_pool
end

Sidekiq.configure_client do |cfg|
  cfg.redis = redis_pool
end

# Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
Sidekiq::Logging.logger.level =
  BuymaInsider.configuration.logging.sidekiq.severity

