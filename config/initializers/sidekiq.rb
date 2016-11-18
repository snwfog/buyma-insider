require 'logging'
require 'sidekiq'

redis_path = File.expand_path('../../../config/redis.yml', __FILE__)
config     = YAML
               .load_file(redis_path)
               .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

Sidekiq.configure_server do |cfg|
  cfg.redis  = config
  cfg.logger = Logging.logger[:Worker]
end

Sidekiq.configure_client do |cfg|
  cfg.redis  = config
  cfg.logger = Logging.logger[:Worker]
end
