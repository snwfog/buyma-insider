class IndexController < ApplicationController
  SHORT_UUID_V4_REGEXP = /\A[0-9a-f]{7}\z/i
  # from https://github.com/ghedamat/ember-deploy-demo/blob/master/edd-rails/app/controllers/demo_controller.rb
  get '/(*)' do
    content_type 'text/html'
    index_key = if BuymaInsider.development?
                  'buyma-insider-client:index:__development__'
                elsif fetch_revision
                  "buyma-insider-client:index:#{fetch_revision}"
                else
                  $redis.with do |store|
                    current_version = store.get('buyma-insider-client:index:current', raw: true)
                    "buyma-insider-client:index:#{current_version}"
                  end
                end
    
    raise 'Index key not found' unless index_key
    index = $redis.with { |store| store.get(index_key, raw: true) }
    index
  end
  
  def fetch_revision
    rev = params[:revision]
    if rev =~ SHORT_UUID_V4_REGEXP
      rev
    end
  end
end