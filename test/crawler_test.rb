require 'ostruct'
require 'buyma_insider'
require 'minitest/autorun'

class Merchant::Indexer::TestMerchant_A < Merchant::Indexer::Base
end

class TestMerchant_A < Merchant::Base
  self.base_url    = 'http://test.com'
  self.index_pages = ['1.html', '2.html']
end


class CrawlerTest < Minitest::Test
  def test_should_respond_to_crawl
    assert_respond_to TestMerchant_A.new, 'crawl'
  end

  def test_should_call_crawl
    crawler = Minitest::Mock.new
    Crawler.stub :new, crawler do
      merchant      = TestMerchant_A.new
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