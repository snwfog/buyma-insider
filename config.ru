require 'sinatra'

raise 'No environment defined' if ENV['ENVIRONMENT'].nil?

set     :env, ENV['ENVIRONMENT']
disable :run

require './app.rb'

run Sinatra::Application


