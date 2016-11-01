require 'minitest/autorun'
require 'buyma_insider'

require_relative './setup_merchant'

class MerchantTest < Minitest::Test
  def setup
    @metadatum = MerchantMetadata.load
  end
  
  def test_should_have_merchant_class
    MerchantMetadata.stub :all, @metadatum do
      assert_equal 4, Merchant::Base.all_merchants.count
    end
  end
  
  def test_should_respond_to_delegate_to_metadata
    MerchantMetadata.stub :all, @metadatum do
      Merchant::Base.all_merchants.each do |m|
        assert_respond_to m, :id
        assert_respond_to m, :code
        assert_respond_to m, :name
        assert_respond_to m, :base_url
        assert_respond_to m, :index_pages
        assert_respond_to m, :item_css
      end
    end
  end
end