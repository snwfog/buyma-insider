require 'redis'

$redis = Redis.new
$r = $redis unless global_variables.include? :$r
