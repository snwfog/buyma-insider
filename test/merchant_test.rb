require 'faker'
require 'minitest/autorun'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'

require 'buyma_insider'
require 'nobrainer'

class TestMerchant_A < Merchant::Base
  self.code = 'tta'
end
class Merchant::Indexer::TestMerchant_A < Merchant::Indexer::Base
end

class TestMerchant_BArticle;
end
class Merchant::Indexer::TestMerchant_B < Merchant::Indexer::Base
end

class TestMerchant_B < Merchant::Base
  self.code        = 'ttb'
  self.base_url    = 'http://merchant-b.com'
  self.index_pages = ['bindex.html']
  self.item_css    = 'b.css'
end

class TestMerchant_CArticle;
end
class Merchant::Indexer::TestMerchant_C < Merchant::Indexer::Base
end

class TestMerchant_C < Merchant::Base
  self.code        = 'ttc'
  self.base_url    = 'http://merchant-c.com'
  self.index_pages = ['cindex.html']
  self.item_css    = 'c.css'
end

class MerchantTest < Minitest::Test
  def test_should_have_and_respond_to_mandatory_class_config
    Merchant::Base.descendants
      .reject { |k| k.to_s =~ /Test/ }
      .each do |m_klazz|
      merchant_instance = m_klazz.new
      
      assert_respond_to m_klazz, :base_url
      assert_respond_to merchant_instance, :base_url
      refute_nil m_klazz.base_url, "#{m_klazz} should have base_url"
      refute_nil merchant_instance.base_url, "#{merchant_instance} should have base_url"
      
      assert_respond_to m_klazz, :item_css
      refute_nil m_klazz.item_css, "#{m_klazz} should have item_css"
      refute_nil merchant_instance.item_css, "#{m_klazz} should have item_css"
      
      assert_respond_to m_klazz, :index_pages
      refute_nil m_klazz.index_pages, "#{m_klazz} should have index_pages"
    end
  end
  
  def test_should_have_merchant_code
    Merchant::Base.descendants.each do |m_klazz|
      refute_nil m_klazz.code, "#{m_klazz} should have merchant code"
      assert m_klazz.code.length == 3, "#{m_klazz} should have merchant code of length 3"
    end
  end
  
  def test_should_all_have_unique_merchant_code
    merchant_codes = Merchant::Base.descendants.map(&:code)
    assert_equal merchant_codes.uniq.sort.to_s, merchant_codes.sort.to_s
  end
  
  def test_should_allow_set_config_options
    assert_equal TestMerchant_B.base_url, 'http://merchant-b.com'
    assert_equal ['bindex.html'], TestMerchant_B.index_pages.map(&:index_path)
    assert_equal 'b.css', TestMerchant_B.item_css
  end
  
  def test_merchant_should_not_override_config
    assert_equal TestMerchant_C.base_url, 'http://merchant-c.com'
    assert_equal ['cindex.html'], TestMerchant_C.index_pages.map(&:index_path)
    assert_equal 'c.css', TestMerchant_C.item_css
  end
  
  def test_should_have_an_valid_indexer
    assert_respond_to TestMerchant_A, :indexer
    assert_equal Merchant::Indexer::TestMerchant_A, TestMerchant_A.indexer
  end
  
  def test_should_have_code_mapped_to_id
    assert_respond_to TestMerchant_A, :code
    assert_respond_to TestMerchant_A.new, :id
    assert_equal TestMerchant_A.new.id, TestMerchant_A.code
  end
end