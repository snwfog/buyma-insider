require 'yaml'
require 'rethinkdb'
require 'buyma_insider'

raise 'Environment missing' unless ENV.has_key? 'ENVIRONMENT'

include RethinkDB::Shortcuts
db_config  = YAML.load_file(File.expand_path('config/database.yml'))
env_config = db_config.deep_symbolize_keys[ENV['ENVIRONMENT'] || :development]

$conn = r.connect(env_config)
