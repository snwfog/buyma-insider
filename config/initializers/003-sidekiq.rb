redis_cfg = BuymaInsider.configuration.redis

Sidekiq.configure_server do |cfg|
  cfg.redis = redis_cfg
end

Sidekiq.configure_client do |cfg|
  cfg.redis = redis_cfg
end

# Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
Sidekiq::Logging.logger.level =
  BuymaInsider.configuration.logging.sidekiq.severity

