require 'redis'
require 'sinatra'
require 'redis-store'
require 'connection_pool'

redis_path = File.expand_path('../../../config/redis.yml', __FILE__)
config     = YAML
               .load_file(redis_path)
               .deep_symbolize_keys[ENV['ENVIRONMENT'].to_sym]

$redis = ConnectionPool.new(size: 5) { Redis::Store.new(config) }
$r     = $redis unless global_variables.include? :$r
# set :cache, $redis
