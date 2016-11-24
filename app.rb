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
  merchant_name, page, count, filter = params.values_at(:merchant, :page, :count, :filter)
  page                               = page ? page.to_i : 1
  count                              = (count.to_i) > 0 ? count.to_i : 20
  filter                             = filter&.to_sym || :all

  merchant = Merchant::Base[merchant_name]
  raise 'Merchant does not exists' unless merchant
  mm       = merchant.metadatum
  articles = case filter
             when :new
               mm.articles.shinchyaku
             when :sale
               mm.articles.yasuuri
             else
               # Default to show all articles
               mm.articles
             end
  render_json articles
                .offset((page - 1) * count)
                .limit(count), meta: { current_page: page,
                                       total_pages:  (articles.count / count.to_f).ceil,
                                       new_count:    mm.shinchyaku.count,
                                       sale_count:   mm.yasuuri.count,
                                       total_count:  mm.articles.count }
end

get '/articles/:id' do
  render_json Article.find(params[:id]), include: '**'
end

# Default hardcoded to JYP, USD, and CAD
get '/rates/latest' do
  render_json ExchangeRate.latest
end

get '/rates' do
  render_json ExchangeRate.limit(20)
end
