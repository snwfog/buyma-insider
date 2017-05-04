class StaticController < ApplicationController
  post '/login' do
    # TODO: Parameterize this
    redirect to('http://localhost:4200/', false)
  end
  
  get '/bootstrap' do
    @bootstrap ||= {
      server_version:                BuymaInsider::VERSION,
      shipping_services:             to_hash(ShippingService.all),
      article_notification_criteria: to_hash(ArticleNotificationCriterium.all)
    }
    
    if user = current_user rescue nil
      @bootstrap['current_user'] = to_hash(user)
    end
    
    @bootstrap.to_json
  end
end