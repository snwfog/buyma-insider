require 'redis'

$redis = Redis.new(host: 'localhost',
                   port: (ENV[:production] ? 65340 : 6379))

$r     = $redis unless global_variables.include? :$r
