require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
require 'sidetiq/web'
run Sidekiq::Web