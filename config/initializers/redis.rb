require 'redis'
require 'connection_pool'

redis_config = YAML.load_file(File.expand_path('config/redis.yml'))
                 .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

$redis = ConnectionPool.new(size: 5) { Redis.new(redis_config) }
$r     = $redis unless global_variables.include? :$r
