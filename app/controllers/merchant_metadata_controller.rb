require_relative './application'
require 'active_model_serializers'

class MerchantMetadataController < ApplicationController
  get '/' do
    json MerchantMetadatum.all
  end

  get '/:merchant_name' do
    param :merchant_name, String, required: true
    
    json MerchantMetadatum.find(params['merchant_name'])
  end
end
