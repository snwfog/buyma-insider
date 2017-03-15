class ApplicationController < Sinatra::Base
  include Elasticsearch::DSL
  
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
  # This setting will let active model serializer serialize
  # all declared relationship, instead of using the resource identifier
  # default serializer that will return only id and type
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
  end
end
