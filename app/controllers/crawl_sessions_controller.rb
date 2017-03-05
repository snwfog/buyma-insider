require_relative './application'

class CrawlSessionsController < ApplicationController
  get '/' do
    json CrawlSession.order_by(created_at: :desc)
  end
  
  get '/:merchant_id' do
    param :merchant_id, Integer, required: true
    
    json CrawlSession.where(merchant_id: params[:merchant_id])
  end
end