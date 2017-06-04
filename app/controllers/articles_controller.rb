class ArticlesController < ApplicationController
  options '/**' do; end
  
  # Do not do this filter if routes start with _
  # before '/(?<!_):id(/**)?' do
  before '/:id(/**)?' do
    pass if params[:id]&.start_with? '_'
    param :id, String, required:  true,
                       transform: :downcase,
                       format:    /[a-z]{3}:[a-z0-9]+/
    
    @article = Article.find?(params[:id])
  end
  
  before '/:id/(watched|sold)', http_methods: [:post, :delete] do
    ensure_user_authenticated!
  end
  
  get '/' do
    param :extension, String, in:        %w(_autocomplete _search),
                              transform: :downcase
    if extension = params[:extension]
      return call env.merge('PATH_INFO' => "/#{extension}")
    end
  
    param :merchant_id, String,  required:  true,
                                 transform: :downcase,
                                 format:    /[a-z]{3}/
    param :page,        Integer, in:        (1..200),
                                 default:   1
    param :limit,       Integer, in:        (1..20),
                                 default:   20
    param :filter,      String
    
    merchant_id, page, limit, filter = params.values_at(*%w(merchant_id page limit filter))
    merchant = Merchant.find!(merchant_id)
    json merchant
           .articles
           .eager_load(:price_history)
           .offset((page - 1) * limit)
           .limit(limit), meta: { current_page:  page,
                                  total_pages:   merchant.articles.count / limit + 1,
                                  total_count:   merchant.articles.count }
  end

  get '/_search' do
    param :q,           String,  required:  true,
                                 transform: :downcase
    param :page,        Integer, in:        (1..200),
                                 default:   1
    param :limit,       Integer, in:        (1..20),
                                 default:   20
    param :order,       String,  transform: :downcase,
                        in:      ['name:asc',
                                  'name:desc',
                                  'price:asc',
                                  'price:desc',
                                  'created_at:asc',
                                  'created_at:desc',
                                  'name',
                                  'price',
                                  'created_at']

    q, page, limit, order = params.values_at(*%w(q page limit order))

    order_by = if order
                 order_key, order_direction = order.split(':')
                 order_direction            ||= 'asc'
                 Hash[order_key, order_direction]
               end
    results  = elasticsearch_search_by_template(:article_name_search,
                                                :article,
                                                article_name_query: q,
                                                order_by:           order_by || [],
                                                size:               limit,
                                                from:               [page - 1, 0].min * limit)

    if documents = results.dig(*%w(hits hits))
      json Article
             .eager_load(:price_history)
             .where(:id.in => documents.map { |article| article['_id'] }),
           meta: { current_page: page,
                   total_pages:  results.dig(*%w(hits total)) / limit + 1,
                   total_count:  results.dig(*%w(hits total)),
                   scores:       documents.map { |article|
                     Hash[:article_id, article['_id'], :score, article['_score']] } }
    else
      json []
    end
  end

  # get '/_autocomplete' do
  #   param :q,     String, required:  true,
  #                         transform: :downcase
  #   # TODO: Allow only single field for now, perhaps later allow multiple fields
  #   param :field, String, transform: -> (f) { f.downcase.to_sym },
  #                         in:        Article.fields.keys,
  #                         default:   :name
  #   param :limit, Integer, in: (1..10), default: 5
  #   param :page,  Integer, in: (1..200), default: 1
  #
  #   q, field, page, limit = params.values_at(*%w(q field page limit))
  #   results = elasticsearch_search_with_template(:article_name_search, :article,
  #                                           params: {
  #                                             article_name_query: q,
  #                                             size:               limit,
  #                                             from:               [page - 1, 0].min * limit })
  #
  #   if results.hits.total.zero?
  #     json []
  #   else
  #     autocompletes = results.hits.hits.map do |article|
  #       Hash[:autocomplete, article.highlight[field],
  #            :id, article._id,
  #            :type, article._type,
  #            :score, article._score]
  #     end
  #
  #     # WARNING: This method is not sorted wrt to elastic relevancy
  #     json Article.where(:id.in => results.hits.hits.map(&:_id)),
  #          meta: { autocompletes: autocompletes,
  #                  total:         results.hits.total }
  #   end
  # end

  get '/:id' do
    json @article
  end

  get '/:id/article_relateds' do
    results = elasticsearch_search_by_template(:article_related_search, :article,
                                               article_name_query:   @article.name,
                                               excluded_article_ids: [@article.id],
                                               size:                 6)
    if results.dig(*%w(hits hits))
      # WARNING: This method is not sorted wrt to elastic relevancy
      json Article
             .eager_load(:price_history)
             .where(:id.in => results
                                .dig(*%w(hits hits))
                                .map { |article| article['_id'] })
    else
      json []
    end
  end
  
  post '/:id/watch' do
    ensure_user_authenticated!
    default_notification_criterium = DiscountPercentArticleNotificationCriterium
                                       .where(threshold_pct: 10)
                                       .first_or_create
    wa_watched = current_user.watch!(@article, default_notification_criterium)
    status :created
    json wa_watched
  end
  
  post '/:id/sell' do
    ensure_user_authenticated!
    request.body.rewind
    payload      = JSON.parse(request.body.read)
    ua_sold_json = as_model(payload)
    # Use json instead of @article here, It give
    # a performance because we don't have to load data
    # This is different than /watch endpoint... for now
    if current_user.id != ua_sold_json[:user_id]
      raise 'Only current user can create sold article'
    else
      ua_sold = current_user.sold!(ua_sold_json)
      status :created
      json ua_sold
    end
  end
  
  delete '/:id/watch' do
    ensure_user_authenticated!
    current_user.destroy_user_article_watched!(@article)
    status :no_content
  end

  delete '/:id/sell' do
    ensure_user_authenticated!
    current_user.destroy_user_article_sold!(@article)
    status :no_content
  end
end