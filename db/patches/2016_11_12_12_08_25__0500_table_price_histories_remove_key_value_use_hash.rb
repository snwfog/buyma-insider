require 'rethinkdb'
require 'patches/setup'

# Take all price histories in the database
# convert from { "2016-11-10 HH:MM:SS": _price_ }
# to { created_at: "2016-11-10 HH:MM:SS", price: _price_ }