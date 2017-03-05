require_relative './application'
require 'active_model_serializers'

class MerchantMetadataController < ApplicationController
  get '/' do
    json MerchantMetadatum.all
  end

  get '/:merchant_id' do
    param :merchant_name, String, required: true, transform: :downcase, format: /[a-z]{3}/
    json MerchantMetadatum.find!(params[:merchant_name])
  end
end
