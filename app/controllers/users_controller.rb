class UsersController < ApplicationController
  before '/:id(/**)?' do
    ensure_user_authenticated!
    
    param :id, String, required: true
    @user = User.find?(params[:id])
  end
  
  get '/:id/article_watcheds' do
    json @user.user_article_watcheds
  end

  get '/:id/article_solds' do
    json @user.user_article_solds
  end
  
  get '/:id/article_notifieds' do
    json @user.user_article_notifieds
  end
  
  get '/:id' do
    json @user
  end
  
  post '/' do
    request.body.rewind
    user_payload = request.body.read
    user_hash    = as_model(user_payload)
  end
end