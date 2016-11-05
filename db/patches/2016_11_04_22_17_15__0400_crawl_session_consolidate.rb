require 'rethinkdb'
require 'patches/setup'

# This patch consolidate the newly created crawl
# session which replaces all crawl histories

r.table('crawl_histories').group do |match|
  [match['merchant_id'],
   match['created_at'].year(),
   match['created_at'].month(),
   match['created_at'].day()]
end.run($conn).each do |record|
  info, crawl_histories = *record
  merchant_id, *date    = *info

  session = CrawlSession.create!(merchant_id: merchant_id,
                                 created_at:  crawl_histories.map{|h| h['created_at']}.min,
                                 updated_at:  crawl_histories.map{|h| h['updated_at']}.min)

  crawl_histories.each do |history|
    r.table('crawl_histories').get(history['id']).update(crawl_session_id: session.id).run($conn)
    #   r.table('articles')
    #   .get(record['id'])
    #   .replace do |article|
    #   article.without('_type')
    # end.run($conn)
  end
end
