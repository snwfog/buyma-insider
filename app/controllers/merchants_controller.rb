class MerchantsController < ApplicationController
  options '/**' do
  end

  before do
    # @merchants_map_by_code = settings.cache.fetch(:merchants) do |key|
    #   settings.cache[key] ||= Hash[Merchant.includes([{ index_pages: :index_pages]}
    #                                  .all.map { |m| [m.code, m] }]
    # end
  end

  before '/:merchant_code(/**)?' do
    param :merchant_code, String, required: true, transform: :downcase, in: Merchant.all.pluck(:code), format: /[a-z]{3}/
    param :limit, Integer, in: (1..20), default: 20
    param :page, Integer, in: (1..1000), default: 1
    param :order, String, transform: :downcase, in: ['name:asc',
                                                     'name:desc',
                                                     'price:asc',
                                                     'price:desc',
                                                     'created_at:asc',
                                                     'created_at:desc',
                                                     'updated_at:asc',
                                                     'updated_at:desc',
                                                     'name',
                                                     'price',
                                                     'created_at',
                                                     'updated_at']

    # @merchant             = @merchants_map_by_code.fetch(params[:merchant_code])

    @merchant            = Merchant
                             .includes(index_pages: :index_pages)
                             .find_by_code(params[:merchant_code])
    @page, @limit, order = params.values_at(*%w(page limit order))
    @order_by            = if order
                             order_key, order_direction, *_ = "#{order}:asc".split(?:).each(&:to_sym)
                             Hash[order_key.to_sym, order_direction.to_sym]
                           end || {}
  end

  get '/' do
    json Merchant.includes(index_pages: :index_pages).all, include: [:metadatum]
  end

  get '/:merchant_code' do
    json @merchant, include: [:metadatum]
  end

  get '/:merchant_code/articles' do
    total_article_count = @merchant.articles.count

    json @merchant.articles
           .eager_load(:price_histories)
           .order(@order_by)
           .offset((@page - 1) * @limit)
           .limit(@limit),
         meta: { current_page: @page,
                 limit:        @limit,
                 total_pages:  (total_article_count / @limit.to_f).floor,
                 total_count:  total_article_count }
  end

  post '/:merchant_code/_groom_index_pages' do
    ensure_user_authenticated!

    if IndexPageWorker.perform_async(@merchant.code)
      status :created
      json data: { type: 'merchant_groom_index_pages',
                   id:   SecureRandom.hex(4) }
    else
      status :conflict and halt
    end
  end
end