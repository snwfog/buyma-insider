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
    @ua_notified.update!(ua_notified_json)
    status :ok
    json @ua_notified
  end
  
  get '/:id' do
    json @ua_notified
  end
end