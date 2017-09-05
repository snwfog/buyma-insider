module CacheHelper
  def write(key, value, options = {})
    with_cache(options) do |redis_store|
      redis_store.set(key, value, options)
    end
  end

  def read(key, options = {})
    with_cache(options) { |cache| cache.get(key, options) }
  end

  def fetch(key, options = {})
    unless data = read(key, options)
      data = yield if block_given?
    end

    write(key, data, options)
    data
  end

  def exists?(key, options = {})
    with_cache(options) { |cache| cache.exists?(key) }
  end

  def delete(key, options = {})
    with_cache(options) { |cache| cache.delete(key) }
  end

  private
  def with_cache(options, &block)
    $redis.with do |redis_pool|
      namespace = options.delete(:namespace) || self.class.name.underscore.gsub('_controller', '')
      redis_pool.with_namespace(namespace) do |redis_store|
        block.call(redis_store)
      end
    end
  end
end