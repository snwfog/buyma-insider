$LOAD_PATH.unshift(File.expand_path('lib'), File.dirname(__FILE__))

require 'sidekiq'
require 'sidetiq'
require 'logging'
require 'buyma_insider'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
  config.logger = Logging.logger[:Worker]
end

require 'sidekiq/web'
require 'sidetiq/web'
Sidekiq::Web.run!


