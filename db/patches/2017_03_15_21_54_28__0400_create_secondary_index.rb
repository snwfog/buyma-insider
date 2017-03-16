require './setup'

# Create secondary indices
# Article.merchant_id
unless r.table('articles').index_list().run
         .include?('merchant_id')
  r.table('articles').index_create('merchant_id').run
end

# CrawlHistory.index_page_id
unless r.table('crawl_histories').index_list().run
         .include?('index_page_id')
  r.table('crawl_histories').index_create('index_page_id').run
end

# CrawlHistory.crawl_session_id
unless r.table('crawl_histories').index_list().run
         .include?('crawl_session_id')
  r.table('crawl_histories').index_create('crawl_session_id').run
end

# CrawlSession.merchant_id
unless r.table('crawl_sessions').index_list().run
         .include?('merchant_id')
  r.table('crawl_sessions').index_create('merchant_id').run
end

# IndexPage.merchant_id
unless r.table('index_pages').index_list().run
         .include?('merchant_id')
  r.table('index_pages').index_create('merchant_id').run
end

# Not used for now
# IndexPageArticle.index_page_id
# unless r.table('articles').index_list().run
#          .include?('merchant_id')
#   r.table('articles').index_create('merchant_id').run
# end

# IndexPageArticle.article_id
# unless r.table('articles').index_list().run
#          .include?('merchant_id')
#   r.table('articles').index_create('merchant_id').run
# end

# PriceHistory.article_id
unless r.table('price_histories').index_list().run
         .include?('article_id')
  r.table('price_histories').index_create('article_id').run
end
