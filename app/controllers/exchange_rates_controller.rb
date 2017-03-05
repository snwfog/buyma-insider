require_relative './application'

class ExchangeRatesController < ApplicationController
  get '/' do
    json ExchangeRate.limit(20)
  end

  # Default hardcoded to JYP, USD, and CAD
  get '/latest' do
    json ExchangeRate.latest
  end
end
