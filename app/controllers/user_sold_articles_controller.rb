class UserSoldArticlesController < ApplicationController
  options '/**' do; end
  
  before '/:id(/**)?' do
    param :id, String, required: true
    
    @user_sold_article = UserSoldArticle.find!(params[:id])
  end
  
  get '/:id' do
    json @user_sold_article
  end

  patch '/:id' do
    request.body.rewind
    payload                = JSON.parse(request.body.read)
    user_sold_article_json = as_model(payload)
    if current_user.id != user_sold_article_json[:user_id]
      raise 'Only current user can update sold article'
    else
      @user_sold_article.update!(user_sold_article_json)
      status :ok
      json @user_sold_article
    end
  end
end