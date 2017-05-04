class UserArticleSoldsController < ApplicationController
  options '/**' do; end
  
  before '/:id(/**)?' do
    param :id, String, required: true
    
    @ua_sold = UserArticleSold.find!(params[:id])
  end
  
  get '/:id/shipping_services' do
    json @ua_sold.shipping_services
  end
  
  get '/:id' do
    json @ua_sold
  end

  patch '/:id' do
    request.body.rewind
    payload      = JSON.parse(request.body.read)
    ua_sold_json = as_model(payload)
    if current_user.id != ua_sold_json[:user_id]
      raise 'Only current user can update sold article'
    else
      @ua_sold.update!(ua_sold_json)
      status :ok
      json @ua_sold
    end
  end
end