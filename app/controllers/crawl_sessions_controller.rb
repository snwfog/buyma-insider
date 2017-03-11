class CrawlSessionsController < ApplicationController
  get '/:merchant_id' do
    param :merchant_id, String, required: true, transform: :downcase, format: /[a-z]{3}/
  
    merchant_id = params.values_at(:merchant_id)
    json CrawlSession.where(merchant_id: merchant_id)
  end
end