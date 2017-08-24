class ExchangeRatesController < ApplicationController
  # Default hardcoded to JYP, USD, and CAD
  get '/latest' do
    json ExchangeRate.latest
  end

  get '/' do
    param :limit, Integer, in: (1..100), default: 20
    json ExchangeRate
           .order(timestamp: :desc)
           .limit(params[:limit])
  end

  get '/:id' do
    param :id, String, required: true
    json ExchangeRate.find(params[:id])
  end
end
