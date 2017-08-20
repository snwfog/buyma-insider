class ArticlesController < ApplicationController
  options '/**' do
    ;
  end

  # Do not do this filter if routes start with _
  # before '/(?<!_):id(/**)?' do
  before '/:id(/**)?' do
    pass if params[:id]&.start_with? '_'
    param :id, String, required: true,
          transform:             :downcase
    # format:    /[a-z]{3}:[a-z0-9]+/

    @article = Article.find(params[:id])
  end

  before '/:id/(watch|sell)', http_methods: [:post, :delete] do
    ensure_user_authenticated!
  end

  get '/' do
    param :extension, String, in: %w(_autocomplete _search), transform: :downcase
    if extension = params[:extension]
      return call env.merge('PATH_INFO' => "/#{extension}")
    end

    param :merchant_id, String, required: true, transform: :downcase, format: /[a-z]{3}/
    param :page, Integer, in: (1..200), default: 1
    param :limit, Integer, in: (1..20), default: 20
    param :filter, String

    merchant_id, page, limit, filter = params.values_at(*%w(merchant_id page limit filter))
    merchant                         = Merchant.find_by_code(merchant_id)
    merchant_total_article_count     = merchant.articles.count
    json merchant
           .articles
           .eager_load(:price_histories)
           .offset((page - 1) * limit)
           .limit(limit), meta: { current_page: page,
                                  total_pages:  (merchant_total_article_count / limit.to_f).ceil,
                                  total_count:  merchant_total_article_count }
  end

  get '/_search' do
    param :q, String, required: true, transform: :downcase
    param :page, Integer, in: (1..200), default: 1
    param :limit, Integer, in: (1..20), default: 20
    param :order, String, transform: :downcase, in: ['name:asc',
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
    results  = elasticsearch_search_by_template(:article_search, :article,
                                                article_name_query: q,
                                                order_by:           order_by || [],
                                                size:               limit,
                                                from:               [page - 1, 0].max * limit)

    if documents = results.dig(*%w(hits hits))
      total_article_count = results.dig(*%w(hits total))
      json Article
             .eager_load(:price_histories)
             .where(id: documents.map { |article| article['_id'] }),
           meta: { current_page: page,
                   total_pages:  (total_article_count / limit.to_f).ceil,
                   total_count:  total_article_count,
                   scores:       documents.map { |article|
                     Hash[:article_id, article['_id'], :score, article['_score']] } }
      # else
      #   json []
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
             .eager_load(:price_histories)
             .where(id: results
                          .dig(*%w(hits hits))
                          .map { |article| article['_id'] })
    end
  end

  post '/:id/watch' do
    wa_watched = current_user.watch_article!(@article)
    status :created
    json wa_watched
  end

  post '/:id/sell' do
    request.body.rewind
    payload      = JSON.parse(request.body.read)
    ua_sold_attr = as_model(payload)
    ua_sold_attr.merge!(price_history: @article.price_histories.last,
                        status:        :confirmed)
    ua_sold = current_user.user_article_solds.create!(ua_sold_attr)
    status :created
    json ua_sold
  end

  delete '/:id/watch' do
    current_user.article_watcheds.destroy(@article)
    status :no_content
  end

  delete '/:id/sell' do
    current_user.article_solds.destroy(@article)
    status :no_content
  end
end
