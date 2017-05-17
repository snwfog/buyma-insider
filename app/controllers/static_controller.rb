class StaticController < ApplicationController
  SHORT_UUID_V4_REGEXP = /\A[0-9a-f]{7}\z/i
  # from https://github.com/ghedamat/ember-deploy-demo/blob/master/edd-rails/app/controllers/demo_controller.rb
  get '/index' do
    content_type 'text/html'
    index_key = if BuymaInsider.development?
                  'buyma-insider-client:index:__development__'
                elsif fetch_revision
                  "buyma-insider-client:index:#{fetch_revision}"
                else
                  $redis.with do |store|
                    "buyma-insider-client:index:#{store.get('buyma-insider-client:index:current')}"
                  end
                end
    
    raise 'Index not found' unless index_key
    index = $redis.with { |store| store.get(index_key, raw: true) }
    index
  end
  
  def fetch_revision
    rev = params[:revision]
    if rev =~ SHORT_UUID_V4_REGEXP
      rev
    end
  end
  
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