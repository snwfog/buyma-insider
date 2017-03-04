require_relative './application'

class ExchangeRatesController < ApplicationController
  get '/' do
    render_json ExchangeRate.limit(20)
  end

  # Default hardcoded to JYP, USD, and CAD
  get '/latest' do
    render_json ExchangeRate.latest
  end
end
