require 'sentry-raven'

Raven.inject_only :sidekiq

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = [ ENV['ENVIRONMENT'] || :development ]
end