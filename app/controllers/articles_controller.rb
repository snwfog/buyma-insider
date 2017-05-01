class ArticlesController < ApplicationController
  include Elasticsearch::DSL
  
  options '/**' do; end
  
  before '/:id(/**)?' do
    param :id, String, required:  true,
                       transform: :downcase,
                       format:    /[a-z]{3}:[a-z0-9]+/
    
    @article = Article.find?(params[:id])
  end
  
  before '/:id/(watched|sold)', http_methods: [:post, :delete] do
    ensure_user_authenticated!
  end
  
  get '/' do
    param :extension,   String, in: %w(_autocomplete _search), transform: :downcase
    if extension = params[:extension]
      return call env.merge('PATH_INFO' => "/#{extension}")
    end
  
    param :merchant_id, String, required: true, transform: :downcase, format: /[a-z]{3}/
    param :page,        Integer, in: (1..200), default: 1
    param :limit,       Integer, in: (1..20), default: 20
    param :filter,      String
    
    merchant_id, page, limit, filter = params.values_at(*%w(merchant_id page limit filter))
    merchant = Merchant.find!(merchant_id)
    json merchant.articles
           .offset((page - 1) * limit)
           .limit(limit), meta: { current_page:  page,
                                  total_pages:   merchant.articles.count / limit + 1,
                                  total_count:   merchant.articles.count }
  end
  
  get '/_autocomplete' do
    param :q,     String, required:  true,
                          transform: :downcase
    # TODO: Allow only single field for now, perhaps later allow multiple fields
    param :field, String, transform: -> (f) { f.downcase.to_sym },
                          in:        Article.fields.keys,
                          default:   :name
    param :limit, Integer, in: (1..10), default: 5
    param :page,  Integer, in: (1..200), default: 1

    q, field, page, limit = params.values_at(*%w(q field page limit))
    body            = { query:     { query_string: { query:  q,
                                                     fields: [field] } },
                        size:      limit,
                        from:      (page - 1) * limit,
                        highlight: {
                          # tags_schema:         :styled,
                          fields:              Hash[field, Hash[]],
                          require_field_match: true
                        } }
  
    results = elasticsearch_query body: body
    if results.hits.total.zero?
      json []
    else
      autocompletes = results.hits.hits.map do |article|
        Hash[:autocomplete, article.highlight[field],
             :id, article._id,
             :type, article._type,
             :score, article._score]
      end

      json Article.where(:id.in => results.hits.hits.map(&:_id)),
           meta: { autocompletes: autocompletes,
                   total:         results.hits.total }
    end
  end

  get '/_search' do
    param :q,            String, required: true, transform: :downcase
    param :page,         Integer, in: (1..200), default: 1
    param :limit,        Integer, in: (1..20), default: 20
  
    q, page, limit = params.values_at(*%w(q page limit))
    body = { from:  (page - 1) * limit,
             size:  limit,
             query: {
               query_string: {
                 query: q } } }
  
    results = elasticsearch_query body: body
    if results.hits.total.zero?
      json []
    else
      json Article.where(:id.in => results.hits.hits.map(&:_id))
    end
  end

  get '/:id' do
    json @article
  end
  
  post '/:id/watch' do
    user_article_watched = current_user.create_user_article_watched!(@article)
    status :created
    json user_article_watched
  end
  
  post '/:id/sell' do
    request.body.rewind
    payload                = JSON.parse(request.body.read)
    user_article_sold_json = as_model(payload)
    # Use json instead of @article here, It give
    # a performance because we don't have to load data
    # This is different than /watch endpoint... for now
    if current_user.id != user_article_sold_json[:user_id]
      raise 'Only current user can create sold article'
    else
      user_sold_article      = current_user.sold!(user_article_sold_json)
      status :created
      json user_sold_article
    end
  end
  
  delete '/:id/watch' do
    current_user.destroy_user_article_watched!(@article)
    status :no_content
  end

  delete '/:id/sell' do
    current_user.destroy_user_article_sold!(@article)
    status :no_content
  end
end