require 'redis'

$redis = Redis.new(host: 'localhost')
$r     = $redis unless global_variables.include? :$r
