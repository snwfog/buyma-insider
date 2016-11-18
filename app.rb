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

get '/merchant_metadata' do
  render_json MerchantMetadatum.all
end

get '/merchant_metadata/:id' do
  render_json MerchantMetadatum.find(params['id'])
end

get '/crawl_histories' do
  render_json CrawlHistory.all
end

get '/crawl_histories/:merchant_id' do
  render_json CrawlSession
                .where(merchant_id: params[:merchant_id])
                .order_by(created_at: :desc)
                .limit(10)
                .all
end

get '/crawl_sessions' do
  sessions = if params.key? 'merchant'
               CrawlSession.where(merchant_id: params[:merchant])
             else
               CrawlSession
             end
  render_json sessions.all
end

get '/articles' do
  merchant_id, page, count = params.values_at(:merchant, :page, :count)
  page                     = (page.to_i < 1) ? 1 : page.to_i
  count                    = (count.to_i) > 0 ? count.to_i : 20

  raise 'Parameter missing' if merchant_id.nil?
  articles = Article.where(merchant_id: merchant_id)
  render_json articles
                .offset(page * count)
                .limit(count), meta: { current_page: page,
                                       total_pages:  (articles.count / count.to_f).ceil,
                                       total_count:  articles.count }
end

get '/articles/:id' do
  render_json Article.find(params[:id]), include: '**'
end


