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
end