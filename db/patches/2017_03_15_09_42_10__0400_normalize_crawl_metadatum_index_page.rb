require_relative './setup'

r.table('merchant_metadata')
  .update { |meta| { domain: meta['base_url'] } }
  .run

r.table('merchant_metadata')
  .replace { |meta| meta.without('base_url') }
  .run

merchants = Hash[Merchant.all.map { |m| [m.id, m] }]
cur_chist = r.table('crawl_histories').run
cur_chist.each do |chist|
  link          = chist['link']
  merchant      = merchants[chist['merchant_id']]
  relative_path = link.gsub!(merchant.metadatum.domain, '')[1..-1]

  idx = IndexPage.upsert!(merchant:      merchant,
                          relative_path: relative_path)

  crawl_history = CrawlHistory.find(chist['id'])
  crawl_history.update!({ index_page: idx })
end

r.table('crawl_histories')
  .replace { |chist| chist.without(%w(link merchant_id)) }.run