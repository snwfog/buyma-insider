require 'yaml'
require 'rethinkdb'
require 'buyma_insider'

raise 'Environment missing' unless ENV.has_key? 'ENVIRONMENT'

include RethinkDB::Shortcuts
rethinkdb_config = YAML.load_file(File.expand_path('config/database.yml'))
                     .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]
$conn            = r.connect(rethinkdb_config)
