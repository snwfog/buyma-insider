# Not working
module CacheableModel
  extend ActiveSupport::Concern
  
  def self.included(model_class)
    model_class.class_eval do
      # TODO: Think about this...
      @@_cache ||= LruRedux::ThreadSafeCache.new(1_000)
  
      around_initialize :fetch_from_cache
      after_save        :save_to_cache
      after_destroy     :delete_from_cache
    end
  end
  
  def fetch_from_cache(*args, &block)
    unless model = @@_cache.get(id)
      model = yield
      @@_cache.set(id, model)
    end
    
    model
  end
  
  def set_to_cache
    @@_cache.set(id, self)
  end
  
  def delete_from_cache
    @@_cache.delete(id)
  end
  
  # module PrependedSingletonMethods
  #   @@_all ||= LruRedux::ThreadSafeCache.new(1_000)
  #   def all(*args)
  #     criteria = super()
  #     if opts = args.pop and opts[:cached] == :ok
  #       key = "cache:models:#{self.class}s".downcase!
  #       @@_all.getset(key) { criteria.to_a }
  #     else
  #       criteria
  #     end
  #   end
  #
  #   private
  #   # def cache_fetch(criteria, namespace)
  #   #   $redis.with_namespace(namespace) do |redis|
  #   #     unless @@_all = redis.get(:all)
  #   #       @@_all = criteria.to_a
  #   #       redis.set(:all, @@_all, expires_in: 5.minutes)
  #   #     end
  #   #
  #   #     @@_all
  #   #   end
  #   # end
  # end
end