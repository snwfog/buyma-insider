require 'active_support/cache'
require 'redis-activesupport'
require 'active_model_serializers'

AMS = ::ActiveModelSerializers unless defined? AMS

AMS.config.adapter         = :json_api
# AMS.config.cache_store     = ActiveSupport::Cache::RedisStore
AMS.config.cache_store     = ActiveSupport::Cache::RedisStore.new(pool: $redis)
#   RedisStore.new "localhost:6379/0", "localhost:6380/0", pool_size: 5, pool_timeout: 10
AMS.config.perform_caching = true
# AMS.config.key_transform = :underscore

