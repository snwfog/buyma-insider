require_relative './application'

class MerchantMetadataController < ApplicationController
  get '/' do
    render_json MerchantMetadatum.all
  end

  get '/:merchant_name' do
    param :merchant_name, String, required: true
  
    render_json MerchantMetadatum.find(params['merchant_name'])
  end
end
