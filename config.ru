# $LOAD_PATH.unshift(File.expand_path('app'), File.dirname(__FILE__))

require 'sidekiq/web'
require 'sidetiq/web'
# require 'require_all'
# require_all 'buyma_insider/workers'

raise 'No environment defined' if ENV['ENVIRONMENT'].nil?

redis_config = YAML
                 .load_file(File.expand_path('config/redis.yml'))
                 .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

Sidekiq.configure_client { |config| config.redis = redis_config }
run Sidekiq::Web
