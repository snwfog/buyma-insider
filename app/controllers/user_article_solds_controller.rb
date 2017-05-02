class UserArticleSoldsController < ApplicationController
  options '/**' do; end
  
  before '/:id(/**)?' do
    param :id, String, required: true
    
    @user_article_sold = UserArticleSold.find!(params[:id])
  end
  
  get '/:id/shipping_services' do
    json @user_article_sold.shipping_services
  end
  
  get '/:id' do
    json @user_article_sold
  end

  patch '/:id' do
    request.body.rewind
    payload                = JSON.parse(request.body.read)
    user_article_sold_json = as_model(payload)
    if current_user.id != user_article_sold_json[:user_id]
      raise 'Only current user can update sold article'
    else
      @user_article_sold.update!(user_article_sold_json)
      status :ok
      json @user_article_sold
    end
  end
end