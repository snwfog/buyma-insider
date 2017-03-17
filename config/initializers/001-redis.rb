$redis = ConnectionPool.new(size: 5) do
  Redis::Store.new(BuymaInsider.configuration.redis.to_h)
end

# set :cache, $redis
