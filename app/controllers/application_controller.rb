class ApplicationController < Sinatra::Base
  include Elasticsearch::DSL
  
  register Sinatra::CrossOrigin
  
  helpers Sinatra::Param
  helpers Sinatra::Cookies
  
  helpers ::RouteHelper
  helpers ::JsonHelper
  helpers ::ElasticsearchHelper
  helpers ::AuthenticationHelper
  
  disable :run
  disable :static
  disable :views
  disable :show_exceptions

  # Contrib
  enable :cross_origin
  
  # Custom
  enable :logging
  
  # Settings
  # explicitly set this
  set :environment, BuymaInsider.environment

# set :env, ENV['RACK_ENV'] # this is default
  
  # Custom settings
  # This setting will let active model serializer serialize
  # all declared relationship, instead of using the resource identifier
  # default serializer that will return only id and type
  enable :deep_serialization
  
  # Global constants
  set :SESSION_TOKEN, :_t
  
  configure :development do
    require 'sinatra/reloader'
    
    register Sinatra::Reloader
    also_reload './app/serializers/*.rb'
  end
  
  configure :production do
    # Sinatra log request to file as well as STDOUT
    use Rack::CommonLogger, Logging.logger[:Sinatra]
  end
  
  before do
    content_type :json
  end
  
  def current_user
    User.first
  end
  
  def ensure_current_user
    ensure_user_authenticated
  end
  
  def ensure_user_authenticated
    User.first # raise 'User not logged in'
  end
end