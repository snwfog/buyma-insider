require 'buyma_insider'

include RethinkDB::Shortcuts
r.connect(db: "buyma_insider_#{ENV['RACK_ENV']}").repl
