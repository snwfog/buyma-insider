redis_cfg = BuymaInsider.configuration.redis.to_h

Sidekiq.configure_server do |cfg|
  cfg.redis = redis_cfg
end

Sidekiq.configure_client do |cfg|
  cfg.redis = redis_cfg
end

Sidekiq::Logging.logger.level = BuymaInsider.configuration.log.sidekiq.severity
