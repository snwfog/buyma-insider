require 'yaml'
require 'rethinkdb'
require 'buyma_insider'

raise 'Environment missing' unless ENV.has_key? 'environment'

include RethinkDB::Shortcuts
db_config  = YAML.load_file(File.expand_path('config/database.yml'))
env_config = db_config.deep_symbolize_keys[ENV['environment'] || :development]

$conn = r.connect(env_config)
