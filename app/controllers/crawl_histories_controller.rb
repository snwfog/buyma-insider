require_relative './application'

class CrawlHistoriesController < ApplicationController
  get '/:merchant_id' do
    param :merchant_id, Integer, required: true
    param :limit, Integer, min: 0, max: 200, default: 20
    
    json CrawlSession
           .where(merchant_id: params[:merchant_id])
           .limit(params[:limit])
  end
end