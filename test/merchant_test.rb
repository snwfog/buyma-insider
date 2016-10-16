require 'faker'
require 'minitest/autorun'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'

require 'buyma_insider'
require 'nobrainer'

class TestMerchant_A < Merchant::Base; end
class Indexer::TestMerchant_A < Indexer::Base; end

class TestMerchant_BArticle; end
class Indexer::TestMerchant_B < Indexer::Base; end
class TestMerchant_B < Merchant::Base
  self.base_url      = 'http://merchant-b.com'
  self.index_pages   = ['bindex.html']
  self.item_css      = 'b.css'
  self.article_model = TestMerchant_BArticle
end

class TestMerchant_CArticle; end
class Indexer::TestMerchant_C < Indexer::Base; end
class TestMerchant_C < Merchant::Base
  self.base_url      = 'http://merchant-c.com'
  self.index_pages   = ['cindex.html']
  self.item_css      = 'c.css'
  self.article_model = TestMerchant_CArticle
end

class MerchantTest < Minitest::Test
  def test_should_have_and_respond_to_mandatory_class_config
    Merchant::Base.descendants.reject { |k| k.to_s =~ /Test/ }.each do |merchant_klazz|
      merchant_instance = merchant_klazz.new

      assert_respond_to merchant_klazz, :base_url
      assert_respond_to merchant_instance, :base_url
      refute_nil merchant_klazz.base_url, "#{merchant_klazz} should have base_url"
      refute_nil merchant_instance.base_url, "#{merchant_instance} should have base_url"

      assert_respond_to merchant_klazz, :item_css
      refute_nil merchant_klazz.item_css, "#{merchant_klazz} should have item_css"
      refute_nil merchant_instance.item_css, "#{merchant_klazz} should have item_css"

      assert_respond_to merchant_klazz, :index_pages
      refute_nil merchant_klazz.index_pages, "#{merchant_klazz} should have index_pages"

      assert_respond_to merchant_klazz, :article_model
      refute_nil merchant_klazz.article_model, "#{merchant_klazz} should have article_model"
    end
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

  def test_should_raise_if_no_valid_article_model
    assert_respond_to TestMerchant_A, 'article_model'
    error = assert_raises { TestMerchant_A.article_model }
    assert_equal error.message, 'Article model not found'
  end

  def test_should_have_an_valid_indexer
    assert_respond_to TestMerchant_A, :indexer
    assert_equal Indexer::TestMerchant_A, TestMerchant_A.indexer
  end
end