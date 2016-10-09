source 'https://rubygems.org'

gem 'sinatra'
gem 'sidekiq'
gem 'sidetiq'
gem 'nokogiri'
gem 'rethinkdb'
gem 'rest-client'
gem 'require_all'
gem 'rake'
gem 'activesupport'
gem 'dotenv'

gem 'sentry-raven', require: 'sentry-raven-without-integrations'

# Persistence
gem 'nobrainer'
gem 'redis'

# Integration
gem 'slackiq'

# Debugging / Development
gem 'pry'
gem 'hirb'
gem 'coolline'
gem 'colorize'
gem 'awesome_print'
gem 'table_print'

gem 'httplog'
gem 'logging'

# Deployment
gem 'foreman'
gem 'rubocop', require: false

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


