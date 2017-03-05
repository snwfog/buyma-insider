require_relative './application'

class ExchangeRatesController < ApplicationController
  get '/' do
    param :limit, Integer, in: (1..100), default: 20
    json ExchangeRate.limit(params.values_at(:limit))
  end

  # Default hardcoded to JYP, USD, and CAD
  get '/latest' do
    json ExchangeRate.latest
  end
end
