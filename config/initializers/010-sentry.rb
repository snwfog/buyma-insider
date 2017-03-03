require 'sentry-raven'

if ENV['RACK_ENV'] =~ /prod(uction)?/i
  Raven.inject_only :sidekiq
  Raven.configure do |config|
    config.dsn          = ENV['SENTRY_DSN']
    config.environments = [ENV['RACK_ENV']]
  end
end
