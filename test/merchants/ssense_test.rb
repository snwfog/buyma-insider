require 'buyma_insider'
require 'minitest/autorun'

class MerchantSsenseTest < Minitest::Test
  def setup
    @ssense = Ssense.new
  end

  def test_should_have_indexer
    assert_equal Indexer::Ssense, Ssense.indexer
  end
end