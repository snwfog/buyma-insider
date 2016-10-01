require 'buyma_insider'
require 'minitest/autorun'

class Merchant_A < Merchant::Base
  self.base_url    = 'http://test.com'
  self.index_pages = ['1.html', '2.html']
end

class CrawlExecutorTest < Minitest::Test
  def test_should_respond_to_crawl
    assert_respond_to Merchant_A.new, 'crawl'
  end

  def test_should_have_proper_merchant_class
    merchant = Merchant_A.new
    executor = merchant.instance_variable_get(:@executor)
    assert executor
    assert_instance_of Merchant_A, executor.merchant
  end

  def test_should_crawl
    executor_mock = Minitest::Mock.new
    merchant      = Merchant_A.new
    merchant.instance_variable_set(:@executor, executor_mock)

    executor_mock.expect :crawl, nil
    merchant.crawl
    executor_mock.verify
  end
end