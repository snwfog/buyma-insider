require 'buyma_insider'
require 'minitest/autorun'

class UrlCacheTest < Minitest::Test
  class Merchant_A
  end

  def setup
    @cache = UrlCache.new
  end

  def test_url_cache_should_respond_to_sets_methods
    assert_respond_to @cache, :add
    assert_respond_to @cache, :add?
    assert_respond_to @cache, :<<
    assert_respond_to @cache, :include?
  end

  def test_url_cache_should_add_and_exist
    l_1 = 'http://test.com'
    @cache << l_1
    assert @cache.include? l_1
  end
end
