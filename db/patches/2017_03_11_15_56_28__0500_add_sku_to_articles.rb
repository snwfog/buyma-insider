require_relative './setup'

# r.table('articles').update do |article|
#   r.table('articles').get('zar:4080926').merge do |article|
#     { :sku => article['id'].split(':')[1] }
#   end
# end.run(conn)

r.table('articles').update do |article|
  { :sku => article['id'].split(':')[1] }
end.run
