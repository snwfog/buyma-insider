require 'buyma_insider'
require 'minitest/autorun'

class MerchantSsenseTest < Minitest::Test
  def setup
    @ssense = Ssense.new
  end

  def test_should_have_indexer
    assert_equal Indexer::SsenseIndexer, Ssense.indexer
  end

  # def test_crawl
  #   @ssense.crawl
  #
  #   puts @ssense.total_merchant_items
  #   puts @ssense.total_traffic_in_byte
  # end
end