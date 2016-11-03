require 'buyma_insider'
require 'active_support/core_ext/string/inflections'

require 'patches/setup'

maps = {
  'ZaraArticle':       :zar,
  'ShoemeArticle':     :sho,
  'GetoutsideArticle': :get,
  'SsenseArticle':     :sse
}

r.table('articles').run($conn).each do |record|
  type = record['_type']
  print "Updating record:#{record['id']}..."

  if record.has_key? 'merchant_id'
    print 'Skipping updating merchant_id...'
  else
    r.table('articles')
      .get(record['id'])
      .update(merchant_id: maps[type]).run($conn)
    print "Adding merchant_id #{maps[type]}..."
  end

  if record.has_key? '_type'
    r.table('articles')
      .get(record['id'])
      .replace do |article|
      article.without('_type')
    end.run($conn)
    puts 'Removing _type field...'
  else
    puts 'Skipping removing _type field...'
  end
end

