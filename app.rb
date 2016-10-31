require 'buyma_insider'
require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/reloader'

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

