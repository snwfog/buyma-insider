redis_pool = BuymaInsider.redis_for(:sidekiq)

# Client and server share the same pool
# Make sure that the pool contain enough connection
# for all workers
Sidekiq.configure_client { |cfg| cfg.redis = redis_pool }
Sidekiq.configure_server { |cfg| cfg.redis = redis_pool }

sidekiq_cron_cfg_file = File.expand_path('../../sidekiq-cron.yml', __FILE__)
if File.exists?(sidekiq_cron_cfg_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file(sidekiq_cron_cfg_file))
end

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
