require 'buyma_insider'
require 'minitest/autorun'

class MerchantSsenseTest < Minitest::Test
  def setup
    @ssense = Merchant::Ssense.new raw_response: false
  end

  def test_crawl
    @ssense.crawl
  end
end