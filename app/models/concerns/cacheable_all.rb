module CacheableAll
  extend ActiveSupport::Concern
  
  def self.included(model_klazz)
    model_klazz
      .singleton_class
      .prepend(PrependedSingletonMethods)
  end
  
  module PrependedSingletonMethods
    @@_all ||= LruRedux::ThreadSafeCache.new(1_000)
    def all(*args)
      criteria = super()
      if opts = args.pop and opts[:cached] == :ok
        key = "cache:models:#{self.class}s".downcase!
        @@_all.getset(key) { criteria.to_a }
      else
        criteria
      end
    end
    
    private
    # def cache_fetch(criteria, namespace)
    #   $redis.with_namespace(namespace) do |redis|
    #     unless @@_all = redis.get(:all)
    #       @@_all = criteria.to_a
    #       redis.set(:all, @@_all, expires_in: 5.minutes)
    #     end
    #
    #     @@_all
    #   end
    # end
  end
end