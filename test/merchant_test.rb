require 'minitest/autorun'
require 'buyma_insider'

require_relative './setup'

class MerchantTest < Minitest::Test
  def setup
    @metadatum = MerchantMetadatum.load
    MerchantMetadatum.stub :all, @metadatum do
      @merchants = Merchant::Base.all
    end
  end

  def test_should_have_merchant_class
    assert_equal 4, @merchants.count
  end

  def test_should_fetch_merchant
    assert_respond_to Merchant::Base, :all
    assert_respond_to Merchant::Base, :merchants_lookup
    assert_respond_to Merchant::Base, :[]

    MerchantMetadatum.stub :all, @metadatum do
      assert_equal 4, Merchant::Base.all.count
    end
  end

  def test_should_respond_to_delegate_to_metadata
    @merchants.each do |m|
      assert_respond_to m, :id
      assert_respond_to m, :code
      assert_respond_to m, :name
      assert_respond_to m, :base_url
      assert_respond_to m, :index_pages
      assert_respond_to m, :item_css
    end
  end

  def test_should_have_an_valid_indexer
    @merchants.each do |merchant|
      assert_respond_to merchant, :indexer
    end
  end

  def test_should_respond_to_attrs_from_node
    @merchants.each do |merchant|
      assert_respond_to merchant, :attrs_from_node
    end
  end
end