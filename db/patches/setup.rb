require 'buyma_insider'
require 'yaml'
require 'rethinkdb'

include RethinkDB::Shortcuts

rethinkdb_cfg_path = File.expand_path('config/database.yml')
rethinkdb_cfg      = YAML.load_file(rethinkdb_cfg_path)
                       .with_indifferent_access.fetch(ENV['RACK_ENV'])

$conn              = r.connect(rethinkdb_cfg)
