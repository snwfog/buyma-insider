$LOAD_PATH.unshift(File.expand_path('../app', __FILE__))

require 'sidekiq/web'
require 'sidetiq/web'
require 'buyma_insider'

raise 'No environment defined' if ENV['ENVIRONMENT'].nil?

redis_config = YAML
                 .load_file(File.expand_path('config/redis.yml'))
                 .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

Sidekiq.configure_client { |config| config.redis = redis_config }
run Sidekiq::Web

