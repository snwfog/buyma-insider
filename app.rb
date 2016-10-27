require 'buyma_insider'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'

AMS = ActiveModelSerializers

get '/crawl_histories' do
  json CrawlHistory.first
end

get '/articles/:id' do
  if (article = Article.find?(params[:id]))
    json AMS::SerializableResource.new(article)
  else
    not_found
  end
end

