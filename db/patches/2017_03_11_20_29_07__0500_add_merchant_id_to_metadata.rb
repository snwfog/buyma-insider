require_relative './setup'

r.table('merchant_metadata').update do |meta|
  { :merchant_id => meta['id'] }
end.run
