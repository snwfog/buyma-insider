module Concerns
  module UrlCache
    attr_accessor :cache

    def self.included(klazz)
      # klazz.extend ClassMethods
    end

    def cache
      @cache ||= Set.new($redis.smembers(merchant_cache_key))
    end

    def merchant_cache_key
      %Q(merchant:#{self.class.to_s.downcase}:url_cache})
    end

    def cache_url
      resp = if @response.history.count > 1
               @response.history.last
             else
               @response
             end

      cache << resp.net_http_res.uri.to_s
    end

    def flush_cache_url
      $redis.sadd(merchant_cache_key, cache.to_a)
    end
    # module ClassMethods; end
  end
end