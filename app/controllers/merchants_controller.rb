class MerchantsController < ApplicationController
  before do
    @merchants_lookup ||= Hash[Merchant.all.map { |m| [m.id, m] }]
  end
  
  before '/:merchant_id(/**)?' do
    param :merchant_id, String,  required:  true,
                                 transform: :downcase,
                                 in:        @merchants_lookup.keys,
                                 format:    %r{[a-z]{3}}
    
    param :limit,       Integer, in:      (1..20),
                                 default: 20
    
    param :page,        Integer, in:      (1..200),
                                 default: 1

    @merchant     = @merchants_lookup.fetch(params[:merchant_id])
    @page, @limit = params.values_at(*%w(page limit))
  end
  
  get '/' do
    json @merchants_lookup.values
  end

  get '/:merchant_id' do
    json @merchant
  end

  get '/:merchant_id/crawl_sessions' do
    json @merchant.crawl_sessions
           .limit(@limit)
           .finished
  end
  
  get '/:merchant_id/articles' do
    json @merchant.articles
           .offset((@page - 1) * @limit)
           .limit(@limit),
         meta: { current_page: @page,
                 limit:        @limit,
                 total_pages:  @merchant.articles.count / @limit + 1,
                 total_count:  @merchant.articles.count }
  end

  get '/:merchant_id/articles/_search' do
    param :q,           String, required:  true,
                                transform: :downcase
    
    param :field,       String, transform: -> (f) { f.downcase.to_sym },
                                in:        Article.fields.keys,
                                default:   :name
    
    q, field = params.values_at(*%w(q field))

    esq = search {
      query {
        bool {
          must {
            query_string {
              query q
              fields [field]
            }
          }
          
          filter { term(merchant_id: @merchant.id) }
        }
      }
      
      size @limit
      from (@page - 1) * @limit
    }
    
    results = elasticsearch_query body: esq.to_hash
    if results.hits.total.zero?
      []
    else
      json @merchant.articles.where(:id.in => results.hits.hits.map(&:_id))
    end
  end
end