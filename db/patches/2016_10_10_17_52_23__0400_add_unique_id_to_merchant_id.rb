require 'buyma_insider'
require 'patches/setup'
require 'active_support/core_ext/string/inflections'

# .eq_join('id', r.table('price_histories'))
# .filter({ '_type': 'ZaraArticle' })
r.table('articles')
  .run($conn).each do |r|
  if record['id'] =~ /^[a-z]{3}/
    klazz = record['_type'].safe_constantize

    r.table('price_histories')
      .get(record['id'])
      .update(article_id: "#{klazz.merchant_code}:#{record['id']}")
      .run($conn)

    r.table('articles')
      .get(record['id'])
      .update(id: "#{klazz.merchant_code}:#{record['id']}")
      .run($conn)
  end
end

