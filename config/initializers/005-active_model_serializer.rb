require 'active_support/cache'
require 'redis-activesupport'

ActiveModelSerializers.config.adapter              = :json_api
# Emberjs likes dash better than underscore
ActiveModelSerializers.config.key_transform        = :dash
ActiveModelSerializers.config.cache_store          = ActiveSupport::Cache::RedisStore.new(pool: $redis)
#   RedisStore.new "localhost:6379/0", "localhost:6380/0", pool_size: 5, pool_timeout: 10
ActiveModelSerializers.config.perform_caching      = true
ActiveModelSerializers.config.include_data_default = false

