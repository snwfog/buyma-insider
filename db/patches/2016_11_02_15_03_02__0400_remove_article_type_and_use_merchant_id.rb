require 'buyma_insider'
require 'patches/setup'
require 'active_support/core_ext/string/inflections'

maps = {
  'ZaraArticle':       :zar,
  'ShoemeArticle':     :sho,
  'GetoutsideArticle': :get,
  'SsenseArticle':     :sse
}

r.table('articles')
  .run($conn).each do |record|
  type = record['_type']
  r.table('articles')
    .get(record['id'])
    .update(merchant_id: maps[type])

  r.table('articles')
    .get(record['id'])
    .replace(r.row.without('_type'))
end
