require 'sentry-raven'

if ENV['ENVIRONMENT'] =~ /prod(uction)?/i
  Raven.inject_only :sidekiq
  Raven.configure do |config|
    config.dsn          = ENV['SENTRY_DSN']
    config.environments = [:production]
  end
end
