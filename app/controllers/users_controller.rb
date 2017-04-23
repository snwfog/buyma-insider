class UsersController < ApplicationController
  before '/:id(/**)?' do
    ensure_user_authenticated!
    
    param :id, String, required: true
    @user = User.find?(params[:id])
  end
  
  get '/:id/watched_articles' do
    json @user.user_watched_articles
  end

  get '/:id/sold_articles' do
    json @user.user_sold_articles
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