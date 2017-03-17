$redis = ConnectionPool.new(size: 5) do
  Redis::Store.new(BuymaInsider.configuration.redis)
end

# set :cache, $redis
