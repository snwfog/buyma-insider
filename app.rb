$:.unshift(File.expand_path('../app', __FILE__))
$:.unshift(File.expand_path('../config', __FILE__))

require 'buyma_insider'
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/cross_origin'
require 'sinatra/reloader'

register Sinatra::CrossOrigin

enable :cross_origin
set :run, true
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :allow_credentials, true
set :max_age, '1728000'
set :expose_headers, ['Content-Type']

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

get '/merchant_metadatum' do
  render_json MerchantMetadata.all
end

get '/merchant_statuses' do
  render_json MerchantStatus.all
end

get '/crawl_histories' do
  render_json CrawlHistory.all
end

get '/crawl_histories/:id' do
  render_json CrawlHistory.find?(params[:id])
end

get '/articles/:id' do
  render_json Article.find? params[:id]
end

