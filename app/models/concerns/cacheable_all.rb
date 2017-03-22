module CacheableAll
  extend ActiveSupport::Concern
  
  def self.included(model_klazz)
    model_klazz
      .singleton_class
      .prepend(PrependedSingletonMethods)
  end
  
  module PrependedSingletonMethods
    def all(*args)
      criteria = super()
      if opts = args.pop and opts.is_a?(Hash) and opts[:cached] == :ok
        cache_in_redis_and_return(criteria)
      else
        criteria
      end
    end
    
    private
    def cache_in_redis_and_return(criteria)
      $redis.with do |redis|
        redis.with_namespace('cache:models:merchants') do
          merchants = redis.get(:all) || criteria.to_a # fetch it
          redis.setnx(:all, merchants, expires_in: 5.minutes)
          merchants
        end
      end
    end
  end
end