require 'elasticsearch'
require 'rethinkdb'

include RethinkDB::Shortcuts

client = Elasticsearch::Client.new
conn = r.connect
