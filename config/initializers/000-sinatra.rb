# require 'sinatra'
# require 'sinatra/cross_origin'

# Base app bootup checks
# Check for app secret
if ENV['APP_SECRET'].nil?
  raise 'An APP_SECRET must be created'
end