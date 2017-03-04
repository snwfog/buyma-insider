require './app/buyma_insider'
require 'sidekiq/web'
require 'sidetiq/web'

run Sidekiq::Web

