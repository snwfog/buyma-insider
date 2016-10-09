require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

require 'sidekiq/web'
require 'sidetiq/web'

app = Sidekiq::Web
app.set environment: ENV['ENVIRONMENT']
app.set bind: '0.0.0.0'
app.set port: 9292
app.run!