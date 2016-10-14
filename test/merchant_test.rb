require 'faker'
require 'minitest/autorun'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class Merchant_A < Merchant::Base; end
class Indexer::Merchant_A < Indexer::Base; end

class Merchant_BArticle; end
class Indexer::Merchant_B < Indexer::Base; end
class Merchant_B < Merchant::Base
  self.base_url      = 'http://merchant-b.com'
  self.index_pages   = ['bindex.html']
  self.item_css      = 'b.css'
  self.article_model = Merchant_BArticle
end

class Merchant_CArticle; end
class Indexer::Merchant_C < Indexer::Base; end
class Merchant_C < Merchant::Base
  self.base_url      = 'http://merchant-c.com'
  self.index_pages   = ['cindex.html']
  self.item_css      = 'c.css'
  self.article_model = Merchant_CArticle
end

class MerchantTest < Minitest::Test
  def test_should_have_config_and_respond_to_basic_class_config
    assert Merchant_A
    assert_respond_to Merchant_A, 'base_url'
    assert_respond_to Merchant_A, 'index_pages'
    assert_respond_to Merchant_A, 'item_css'
  end

  def test_should_allow_set_config_options
    assert_equal Merchant_B.base_url, 'http://merchant-b.com'
    assert_equal ['bindex.html'], Merchant_B.index_pages.map(&:index_path)
    assert_equal 'b.css', Merchant_B.item_css
  end


  def test_merchant_should_not_override_config
    assert_equal Merchant_C.base_url, 'http://merchant-c.com'
    assert_equal ['cindex.html'], Merchant_C.index_pages.map(&:index_path)
    assert_equal 'c.css', Merchant_C.item_css
  end

  def test_merchant_should_have_article_model
    assert_respond_to Merchant_B, 'article_model'
    assert_respond_to Merchant_C, 'article_model'

    assert_equal Merchant_B.article_model, Merchant_BArticle
    assert_equal Merchant_C.article_model, Merchant_CArticle
  end

  def test_should_raise_if_no_valid_article_model
    assert_respond_to Merchant_A, 'article_model'
    error = assert_raises { Merchant_A.article_model }
    assert_equal error.message, 'No article model'
  end

  def test_should_have_an_valid_indexer
    assert_respond_to Merchant_A, :indexer
    assert_equal Indexer::Merchant_A, Merchant_A.indexer
  end
end