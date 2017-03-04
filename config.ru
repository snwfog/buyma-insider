require './app/buyma_insider'
require 'rack'

# set :env, ENV['RACK_ENV'] # this is default

map('/merchant_metadata') { run MerchantMetadataController }
map('/crawl_histories') { run CrawlHistoriesController }
map('/crawl_sessions') { run CrawlSessionsController }
map('/articles') { run ArticlesController }
map('/rates') { run ExchangeRatesController }


