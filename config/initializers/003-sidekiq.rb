redis_pool = BuymaInsider.redis_for(:sidekiq)

# Client and server share the same pool
# Make sure that the pool contain enough connection
# for all workers
Sidekiq.configure_client { |cfg| cfg.redis = redis_pool }
Sidekiq.configure_server { |cfg| cfg.redis = redis_pool }

if File.exists?('./config/sidekiq-cron.yml') && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(YAML.load_file('./config/sidekiq-cron.yml'))
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

