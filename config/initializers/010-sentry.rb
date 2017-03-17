require 'net/http'
if ENV['RACK_ENV'] =~ /prod(uction)?/i
  Raven.inject_only :sidekiq
  Raven.configure do |config|
    config.dsn          = ENV['SENTRY_DSN']
    config.environments = [:production]
  end
end
