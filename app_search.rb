$:.unshift(File.expand_path('../app', __FILE__))
$:.unshift(File.expand_path('../config', __FILE__))

require 'buyma_insider'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/param'
require 'sinatra/reloader' unless ENV['ENVIRONMENT'] =~ /prod(uction)?/

class AppSearch < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

  get '/articles' do
    param :query, String
    param :q,     String
    any_of :query, :q

    json :ok
  end
end
