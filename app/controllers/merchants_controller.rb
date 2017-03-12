class MerchantsController < ApplicationController
  get '/' do
    json Merchant.all
  end

  get '/:merchant_id' do
    param :merchant_id, String, required:  true,
          transform: -> (f) { f.downcase },
          format:    /[a-z]{3}/
  
    json Merchant.find!(params[:merchant_id])
  end
  
  get '/:merchant_id/crawl_sessions' do
    param :merchant_id, String, required:  true,
          transform: -> (f) { f.downcase },
          format:    /[a-z]{3}/
  
    if merchant = Merchant.find!(params[:merchant_id])
      json merchant.crawl_sessions.limit(20).finished
    end
  end
end