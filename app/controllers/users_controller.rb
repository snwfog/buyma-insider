class UsersController < ApplicationController
  before '/:id(/**)?' do
    ensure_user_authenticated!
    
    param :id, String, required: true
    @user = User.find?(params[:id])
  end
  
  get '/:id' do
    json @user
  end
end