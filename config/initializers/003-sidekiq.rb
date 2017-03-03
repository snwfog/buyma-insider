redis_cfg_path = File.expand_path('../../../config/redis.yml', __FILE__)
redis_cfg      = YAML.load_file(redis_cfg_path)
                   .with_indifferent_access
                   .fetch(ENV['RACK_ENV'])

Sidekiq.configure_server { |cfg| cfg.redis = redis_cfg }
Sidekiq.configure_client { |cfg| cfg.redis = redis_cfg }
