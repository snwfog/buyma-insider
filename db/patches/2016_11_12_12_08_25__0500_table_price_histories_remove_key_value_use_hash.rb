require 'rethinkdb'
require 'patches/setup'

# Take all price histories in the database
# convert from { "2016-11-10 HH:MM:SS": _price_ }
# to { created_at: "2016-11-10 HH:MM:SS", price: _price_ }

r.table('price_histories').run($conn).each do |record|
  updated_history = record.history.map do |date, price|
    { created_at: DateTime.strptime(date, '%F %T %Z'),
      price:      price }
  end
  # r.table('price_histories')
  #   .get(record['id'])
  #   .replace do
end

