class ExchangeRatesController < ApplicationController
  # Default hardcoded to JYP, USD, and CAD
  get '/latest' do
    json ExchangeRate.latest
  end
  
  get '/' do
    param :limit, Integer, in:        (1..100),
          transform: :to_sym,
          default:   20
    json ExchangeRate.limit(params[:limit])
  end
  
  get '/:id' do
    param :id, String, required: true
    json ExchangeRate.find!(params[:id])
  end
end
