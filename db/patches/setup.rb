require 'buyma_insider'

r.connect(db: "buyma_insider_#{ENV['RACK_ENV']}").repl
