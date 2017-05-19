redis_pool = BuymaInsider.redis_for(:sidekiq)

Sidekiq.configure_server { |cfg| cfg.redis = redis_pool }
Sidekiq.configure_client { |cfg| cfg.redis = redis_pool }

# Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
if BuymaInsider.production?
  Sidekiq::Logging.logger.level =
    BuymaInsider.configuration.logging.sidekiq.severity
else
  Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
end

