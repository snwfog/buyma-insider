class UrlCache
  attr_accessor :cache
  delegate :<<, :add, :add?, :include?,
           to: :cache

  def initialize(m)
    @redis_key = "merchant:#{m.to_s}:urls:#{Time.now.utc.to_i.to_s}".downcase
    @cache     ||= Set.new($redis.smembers(@redis_key))
  end

  # def cache_url
  #   resp = if @response.history.count > 1
  #            @response.history.last
  #          else
  #            @response
  #          end
  #
  #   cache << resp.net_http_res.uri.to_s
  # end

  # def flush_cache_url
  #   $redis.sadd(merchant_cache_key, cache.to_a) unless cache.empty?
  # end
end
