require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/param'
require 'sinatra/cross_origin'
require 'sinatra/reloader'

class ApplicationController < Sinatra::Base
  register Sinatra::CrossOrigin

  disable :run
  disable :static
  disable :views
  disable :show_exceptions

  enable :cross_origin
  enable :allow_credentials

  set :allow_origin,    :any
  set :allow_methods,   [:get, :post, :options]
  set :max_age,         '1728000'
  set :expose_headers,  ['content-type']

  helpers do
    def render_json(model, options = {})
      if model
        json AMS::SerializableResource.new(model, options)
      else
        not_found
      end
    end
  end

  before do
    content_type :json
  end
  
end
