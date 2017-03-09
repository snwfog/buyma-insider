class ApplicationController < Sinatra::Base
  disable :run
  disable :static
  disable :views
  disable :show_exceptions

  enable :cross_origin
  enable :allow_credentials
  enable :logging

  set :allow_origin,    :any
  set :allow_methods,   [:get, :post, :options]
  set :max_age,         '1728000'
  set :expose_headers,  ['content-type']
# set :env, ENV['RACK_ENV'] # this is default
  
  # Custom settings
  enable :deep_serialization
  
  configure :development do
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
  
  register Sinatra::CrossOrigin
  
  helpers Sinatra::Param
  helpers ::JsonHelper
  helpers ::ElasticsearchHelper
end
