redis_cfg_path = File.expand_path('../../../config/redis.yml', __FILE__)
redis_cfg      = YAML.load_file(redis_cfg_path)
                   .with_indifferent_access
                   .fetch(ENV['RACK_ENV'])

$redis = ConnectionPool.new(size: 5) do
  Redis::Store.new(redis_cfg)
end

$r     = $redis unless global_variables.include? :$r

# set :cache, $redis
