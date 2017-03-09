require_relative './application'

class ArticlesController < ApplicationController
  include BuymaInsider::Elasticsearch::Queryable
  
  get '/' do
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
  
  get '/_search' do
    param :q,           String
    param :page,        Integer, in: (1..200), default: 1
    param :limit,       Integer, in: (1..20), default: 20
    
    q, page, limit = params.values_at(*%w(q page limit))
    results = elasticsearch_query(body: {
      from:  (page - 1) * limit,
      size:  limit,
      query: {
        query_string: {
          query: q
        }
      }
    })

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