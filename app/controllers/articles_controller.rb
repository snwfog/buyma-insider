require_relative './application'

class ArticlesController < ApplicationController
  get '/' do
    param :merchant, String, required: true
    param :page,     Integer, default: 1
    param :count,    Integer, default: 20
    param :filter,   String, default: 'all'
    
    merchant_name, page, count, filter = params.values_at(:merchant, :page, :count, :filter)
    
    merchant = Merchant::Base[merchant_name]
    raise 'Merchant does not exists' unless merchant
    mm       = merchant.metadatum
    articles = case filter
               when 'new'
                 mm.articles.latests
               when 'sale'
                 mm.articles.sales
               else
                 # Default to show all articles
                 mm.articles
               end
    render_json articles
                  .offset((page - 1) * count)
                  .limit(count), meta: { current_page: page,
                                         total_pages:  (articles.count / count.to_f).ceil,
                                         new_count:    mm.latests.count,
                                         sale_count:   mm.sales.count,
                                         total_count:  mm.articles.count }
  end

  get '/:id' do
    param :id, Integer, required: true
    render_json Article.find(params[:id]), include: '**'
  end
  
  get '/search' do
    param :query, String
    param :q,     String
    any_of :query, :q
  
    json :ok
  end
end