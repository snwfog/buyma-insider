require 'logging'
require 'sidekiq'

redis_config = YAML.load_file(File.expand_path('config/redis.yml'))
                 .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

Sidekiq.configure_server do |config|
  config.redis  = redis_config
  config.logger = Logging.logger[:Worker]
end

Sidekiq.configure_client do |config|
  config.redis  = redis_config
  config.logger = Logging.logger[:Worker]
end
