require 'buyma_insider'
require 'patches/setup'
require 'active_support/core_ext/string/inflections'

# IMPT: This script has a bug...

# .eq_join('id', r.table('price_histories'))
# .filter({ '_type': 'ZaraArticle' })

r.table('articles')
  .run($conn).each do |record|
  unless record['id'] =~ /^[a-z]{3}/
    klazz = record['_type'].safe_constantize

    ph = r.table('price_histories')
           .get(record['id'])
           .run($conn)

    unless ph.nil?
      ph.merge(article_id: "#{klazz.merchant_code}:#{record['id']}")
      r.table('price_histories').insert(ph).run($conn)
      r.table('price_histories').get(record['id']).delete.run($conn)

      art = r.table('articles')
              .get(record['id'])
              .merge(id: "#{klazz.merchant_code}:#{record['id']}")
              .run($conn)

      r.table('articles').insert(art).run($conn)
      r.table('articles').get(record['id']).delete.run($conn)
    end
  end
end
