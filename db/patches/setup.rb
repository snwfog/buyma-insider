require 'buyma_insider'

include RethinkDB::Shortcuts

conn = r.connect(db: "buyma_insider_#{ENV['RACK_ENV']}")
