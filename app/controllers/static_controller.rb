class StaticController < ApplicationController
  post '/login' do
    redirect_to_index
  end

  post '/logout' do
    destroy_session!
    redirect_to_index
  end

  get '/bootstrap' do
    bootstrap_hash =
      fetch('bootstrap', ex: 1.day.to_i) do
        { server_version:                BuymaInsider::VERSION,
          merchants:                     to_hash(Merchant.all, include: [:merchant_metadatum, :index_pages]),
          shipping_services:             to_hash(ShippingService.all),
          extra_tariffs:                 to_hash(ExtraTariff.all),
          article_notification_criteria: to_hash(ArticleNotificationCriterium.all) }
      end

    if user = current_user
      bootstrap_hash['current_user'] = to_hash(user)
    end

    bootstrap_hash.to_json
  end

  SHORT_UUID_V4_REGEXP = /\A[0-9a-f]{7}\z/i
  # from https://github.com/ghedamat/ember-deploy-demo/blob/master/edd-rails/app/controllers/demo_controller.rb
  get '/(*)' do
    # requested_json = request.accept? 'application/vnd.api+json'
    requested_html = request.accept? 'text/html'
    halt 404 unless requested_html
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

  private

  def fetch_revision
    rev = params[:revision]
    if rev =~ SHORT_UUID_V4_REGEXP
      rev
    end
  end

  def redirect_to_index
    if origin = env['HTTP_ORIGIN']
      # cors
      absolute = true
      redirect(to(origin, absolute))
    else
      redirect(to('/', !absolute))
    end
  end
end
