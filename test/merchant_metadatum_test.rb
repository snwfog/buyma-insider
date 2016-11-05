require 'faker'
require 'minitest/autorun'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'

require 'buyma_insider'
require 'nobrainer'

require_relative './setup'
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

class MerchantMetadatumTest < Minitest::Test
  @@merchant_metadata = MerchantMetadatum.load

  def test_should_have_and_respond_to_mandatory_class_config
    @@merchant_metadata.each do |metadata|
      refute_nil metadata.name, "#{metadata} should have a name"
      refute_nil metadata.base_url, "#{metadata} should have base_url"
      # pager_css is not required
      # refute_nil metadata.pager_css, "#{metadata} should have pager_css"
      refute_nil metadata.item_css, "#{metadata} should have item_css"
      refute_nil metadata.index_pages, "#{metadata} should have index_pages"
    end
  end

  def test_should_have_merchant_code
    @@merchant_metadata.each do |merchant|
      refute_nil merchant.code, "#{merchant} should have merchant code"
      assert merchant.code.length == 3, "#{merchant} should have merchant code of length 3"
    end
  end

  def test_should_all_have_unique_merchant_code
    merchant_codes = @@merchant_metadata.map(&:code)
    assert_equal merchant_codes.uniq.sort.to_s, merchant_codes.sort.to_s
  end
end