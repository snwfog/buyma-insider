require 'buyma_insider'
require 'minitest/autorun'

class MerchantSsenseTest < Minitest::Test
  def setup
    @ssense = Merchant::Ssense.new raw_response: false
  end

  def test_crawl
    @ssense.crawl

    puts @ssense.total_merchant_items
    puts @ssense.total_traffic_in_byte
  end
end