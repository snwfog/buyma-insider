class UserArticleNotifiedsController < ApplicationController
  options '/**' do; end
  
  before '/:id(/**)?' do
    param :id, String, required: true
    
    @ua_notified = UserArticleNotified.find!(params[:id])
  end
  
  # Satisfied article notification criteria
  get '/:id/article_notification_criteria' do
    json @ua_notified.article_notification_criteria
  end
  
  patch '/:id' do
    request.body.rewind
    payload          = JSON.parse(request.body.read)
    ua_notified_json = as_model(payload)
    if current_user.id != ua_notified_json[:user_id]
      raise 'Only current user can update notified article'
    else
      @ua_notified.update!(ua_notified_json)
      status :ok
      json @ua_notified
    end
  end
  
  get '/:id' do
    json @ua_notified
  end
end