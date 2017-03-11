source 'https://rubygems.org'

gem 'sinatra',                  github: 'sinatra/sinatra', branch: 'master'
gem 'sinatra-contrib',          require: false
gem 'sinatra-param',            github: 'snwfog/sinatra-param', branch: 'master', require: 'sinatra/param'
gem 'sinatra-cross_origin',     require: 'sinatra/cross_origin'
gem 'sinatra-resources',        require: 'sinatra/resources'
gem 'active_model_serializers', '~> 0.10.0'
gem 'sidekiq'
gem 'sidetiq'
gem 'nokogiri'
gem 'rethinkdb'
gem 'rest-client'
gem 'require_all'
gem 'rake'
gem 'rack'
gem 'activesupport'
gem 'dotenv', require: 'dotenv/load'
gem 'connection_pool'
gem 'hashie'

# Persistence
gem 'nobrainer'
gem 'redis'
gem 'redis-activesupport'
gem 'seed-fu'

# Searching
gem 'elasticsearch'

# Integration
gem 'sentry-raven', require: 'sentry-raven-without-integrations'
gem 'slackiq'
gem 'money-open-exchange-rates' # Money + exchange rates

gem 'httplog'
gem 'logging'

# Deployment
gem 'foreman'
gem 'unicorn' if RUBY_PLATFORM =~ /darwin/

group :development do
  gem 'shotgun'
  gem 'rubocop', require: false
  gem 'pry'
  gem 'hirb'
  gem 'coolline'
  gem 'colorize'
  gem 'awesome_print'
  gem 'table_print'
end

group :test do
  gem 'minitest'
  gem 'rspec'
  gem 'faker'
  gem 'nyan-cat-formatter'
# gem 'redis-stat'
end

case RUBY_PLATFORM
when /darwin/
  gem 'guard'
  gem 'guard-minitest'
end
