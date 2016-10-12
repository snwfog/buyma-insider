$LOAD_PATH.unshift(File.expand_path('lib'), File.dirname(__FILE__))

require 'require_all'
require 'sidekiq'
require 'logging'
require 'buyma_insider'

raise 'Environment missing' unless ENV.has_key? 'ENVIRONMENT'
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

