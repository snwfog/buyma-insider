require 'buyma_insider'
require 'minitest/autorun'

TestMerchant_A = Class.new(Merchant::Base)

class CrawlerTest < Minitest::Test
  def test_should_respond_to_methods
    merchant_stub = Minitest::Mock.new
    crawler = Crawler.new(merchant_stub)
    assert_respond_to crawler, :total_elapsed_time
    assert_respond_to crawler, :stats
  end

  def test_should_respond_to_crawl
    assert_respond_to TestMerchant_A.new(nil), :crawl
  end

  def test_should_call_crawl
    crawler = Minitest::Mock.new
    Crawler.stub :new, crawler do
      merchant      = TestMerchant_A.new(nil)
      crawler.expect :crawl, nil
      merchant.crawl
      crawler.verify
    end
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
  #   Indexer::TestMerchant_A.stub :new, indexer_stub do
  #     executor = CrawlExecutor.new(TestMerchant_A)
  #     executor.crawl('http://merchant-a.com/index.html') { count = count + 1 }
  #     assert_equal 5, count
  #   end
  # end
end