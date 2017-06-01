Sentry = Raven

Raven.inject_only :sidekiq
# :rack,
# :rack-timeout
Raven.configure do |config|
  config.dsn          = ENV['SENTRY_DSN'] unless BuymaInsider.development?
  config.environments = [:staging, :production]
end
