require 'yaml'
require 'rethinkdb'
require 'buyma_insider'

include RethinkDB::Shortcuts
db_config  = YAML.load_file(File.expand_path('config/database.yml'))
env_config = db_config.deep_symbolize_keys[ENV['environment'] || :development]

$conn = r.connect(env_config)
