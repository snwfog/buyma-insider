require 'faker'
require 'minitest/autorun'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'

require 'buyma_insider'
require 'nobrainer'

require_relative './setup_merchant'
#
# class TestMerchant_A < Merchant::Base
#   self.code = 'tta'
# end
#
# class Merchant::Indexer::TestMerchant_A < Merchant::Indexer::Base
# end
#
# class TestMerchant_BArticle;
# end
# class Merchant::Indexer::TestMerchant_B < Merchant::Indexer::Base
# end
#
# class TestMerchant_B < Merchant::Base
#   self.code        = 'ttb'
#   self.base_url    = 'http://merchant-b.com'
#   self.index_pages = ['bindex.html']
#   self.item_css    = 'b.css'
# end
#
# class TestMerchant_CArticle;
# end
# class Merchant::Indexer::TestMerchant_C < Merchant::Indexer::Base
# end
#
# class TestMerchant_C < Merchant::Base
#   self.code        = 'ttc'
#   self.base_url    = 'http://merchant-c.com'
#   self.index_pages = ['cindex.html']
#   self.item_css    = 'c.css'
# end

class MerchantMetadataTest < Minitest::Test
  @@merchants = MerchantMetadata.load
  
  def test_should_have_and_respond_to_mandatory_class_config
    @@merchants.each do |merchant|
      assert_respond_to merchant, :name
      refute_nil merchant.name, "#{merchant} should have a name"
      
      assert_respond_to merchant, :base_url
      refute_nil merchant.base_url, "#{merchant} should have base_url"
      
      assert_respond_to merchant, :pager_css
      refute_nil merchant.pager_css, "#{merchant} should have item_css"
      
      assert_respond_to merchant, :item_css
      refute_nil merchant.item_css, "#{merchant} should have item_css"
      
      assert_respond_to merchant, :index_pages
      refute_nil merchant.index_pages, "#{merchant} should have index_pages"
    end
  end
  
  def test_should_have_merchant_code
    @@merchants.each do |merchant|
      refute_nil merchant.code, "#{merchant} should have merchant code"
      assert merchant.code.length == 3, "#{merchant} should have merchant code of length 3"
    end
  end
  
  def test_should_all_have_unique_merchant_code
    merchant_codes = @@merchants.map(&:code)
    assert_equal merchant_codes.uniq.sort.to_s, merchant_codes.sort.to_s
  end
  
  def test_should_have_an_valid_indexer
    @@merchants.each do |merchant|
      assert_respond_to merchant, :indexer
    end
  end
end