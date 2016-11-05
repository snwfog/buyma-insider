require 'rethinkdb'
require 'patches/setup'

r.table_drop('merchant_metadata').run($conn)
