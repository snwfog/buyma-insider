require 'buyma_insider'
require 'minitest/autorun'

class Merchant_A < Merchant::Base;
end

class CrawlExecutorTest < Minitest::Test
  def test_should_have_proper_merchant_class
    merchant = Merchant_A.new
    executor = merchant.instance_variable_get(:@executor)
    assert executor
    assert_instance_of Merchant_A, executor.merchant
  end
end