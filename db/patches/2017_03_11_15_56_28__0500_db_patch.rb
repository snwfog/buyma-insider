require_relative './setup'

r.table('articles').merge do |article|
  { :sku => article['id'].split(':').last }
end.run(conn)
