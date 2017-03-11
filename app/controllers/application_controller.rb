class ApplicationController < Sinatra::Base
  register Sinatra::CrossOrigin
  
  helpers Sinatra::Param
  helpers ::JsonHelper
  helpers ::ElasticsearchHelper
  
  disable :run
  disable :static
  disable :views
  disable :show_exceptions

  # Contrib
  enable :cross_origin
  
  # Custom
  enable :logging

# set :env, ENV['RACK_ENV'] # this is default
  
  # Custom settings
  enable :deep_serialization
  
  configure :development do
    require 'sinatra/reloader'
    
    register Sinatra::Reloader
    also_reload './app/serializers/*.rb'
  end
  
  configure :production do
    # Sinatra log request to file as well as STDOUT
    use Rack::CommonLogger, Logging.logger['Web']
  end
  
  before do
    content_type :json
    params.with_indifferent_access
  end
end
