require 'buyma_insider'
require 'active_support/core_ext/string/inflections'

require 'patches/setup'

r.table('articles').run($conn).each do |record|
  merchant_id = record['id'].split(':').first
  print "Updating record:#{record['id']}..."

  if record.has_value? 'merchant_id'
    puts "Skipping updating merchant_id:#{record['merchant_id']}"
  else
    r.table('articles')
      .get(record['id'])
      .update(merchant_id: merchant_id).run($conn)
    puts "Adding merchant_id:#{merchant_id}..."
  end
end

