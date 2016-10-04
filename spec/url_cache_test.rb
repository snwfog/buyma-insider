require 'buyma_insider'
require 'minitest/autorun'

class UrlCacheTest < Minitest::Test
  class Merchant_A
  end

  def setup
  end

  def test_should_respond_to_set_method
    @cache = UrlCache.new Merchant_A

    @redis = Minitest::Mock.new
    def @redis.smembers(s); []; end

    Redis.stub :smembers, @redis do
      @cache.must_respond_to :add
      @cache.must_respond_to :add?
      @cache.must_respond_to :<<
    end
  end
end
