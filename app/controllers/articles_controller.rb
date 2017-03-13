class ArticlesController < ApplicationController
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
    articles = if ['latests', 'sales'].include?(filter)
                 merchant.articles.public_send(filter)
               else
                 merchant.articles
               end
  
    json articles
           .offset((page - 1) * limit)
           .limit(limit), meta: { current_page:  page,
                                  total_pages:   (articles.count / limit.to_f).ceil,
                                  latests_count: merchant.articles.latests.count,
                                  sales_count:   merchant.articles.sales.count,
                                  total_count:   merchant.articles.count }

  end

  get '/_autocomplete' do
    param :q,     String, required: true, transform: :downcase
    # TODO: Allow only single field for now, perhaps later allow multiple fields
    param :field, String, transform: -> (f) { f.downcase.to_sym },
                          in:        Article.fields.keys,
                          default:   :name
    param :limit, Integer, in: (1..10), default: 5

    q, field, limit = params.values_at(*%w(q field limit))
    body            = { query:     { query_string: { query:  q,
                                                     fields: [field] } },
                        size:      limit,
                        highlight: {
                          tags_schema:         :styled,
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
    param :id, String, required: true, format: /[a-z]{3}:[a-z0-9]+/
    json Article.find?(params[:id])
  end
end