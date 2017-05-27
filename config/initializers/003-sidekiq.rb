redis_pool = BuymaInsider.redis_for(:sidekiq)

Sidekiq.configure_server { |cfg| cfg.redis = redis_pool }
Sidekiq.configure_client { |cfg| cfg.redis = redis_pool }

# Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
if BuymaInsider.development?
  # On dev log everything to console using logger
  Sidekiq::Logging.logger = Logging.logger[:Sidekiq]
else
  # On production, only respect the logging priority within logging.yml
  # Use the default sidekiq logging facility
  Sidekiq::Logging.logger.level =
    BuymaInsider.configuration.logging.sidekiq.severity
end

