require_relative './application'

class CrawlHistoriesController < ApplicationController
  get '/:merchant_id' do
    param :merchant_id, String, required: true, transform: :downcase, format: /[a-z]{3}/
    param :limit, Integer, in: (1..200), default: 20
    
    merchant_id, limit = params.values_at(:merchant_id, :limit)
    
    json CrawlSession
           .where(merchant_id: merchant_id)
           .limit(limit)
  end
end