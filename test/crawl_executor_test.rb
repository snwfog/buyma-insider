require 'ostruct'
require 'buyma_insider'
require 'minitest/autorun'

class Indexer::Merchant_A < Indexer::Base; end

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
    executor = merchant.instance_variable_get(:@crawler)
    assert executor
    assert_equal Merchant_A, executor.merchant
  end

  def test_should_call_crawl
    executor_mock = Minitest::Mock.new
    merchant      = Merchant_A.new
    merchant.instance_variable_set(:@crawler, executor_mock)

    executor_mock.expect :crawl, nil
    merchant.crawl
    executor_mock.verify
  end

  # def test_url_cache
  #   def Http.get(link)
  #     response_stub = Minitest::Mock.new
  #     def response_stub.body; '<html><head></head><body></body></html>'; end
  #     response_stub
  #   end
  #
  #   count = 0
  #   indexer_stub = Minitest::Mock.new
  #   def indexer_stub.index(_, &blk); (1..5).each(&blk); end
  #
  #   Indexer::Merchant_A.stub :new, indexer_stub do
  #     executor = CrawlExecutor.new(Merchant_A)
  #     executor.crawl('http://merchant-a.com/index.html') { count = count + 1 }
  #     assert_equal 5, count
  #   end
  # end
end