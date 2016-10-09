require 'sentry-raven'

if ENV['ENVIRONMENT'] =~ /(PROD)|(production)/i
  Raven.inject_only :sidekiq
  Raven.configure do |config|
    config.dsn          = ENV['SENTRY_DSN']
    config.environments = [:production]
  end
end
