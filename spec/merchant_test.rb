require 'faker'
require 'minitest/autorun'
require 'active_support'
require 'active_support/core_ext/numeric/time'

require 'buyma_insider'
require 'nobrainer'

class MerchantTest < Minitest::Test

  class Merchant_A < Merchant::Base
  end

  def test_should_have_config_and_respond_to_basic_class_config
    assert Merchant_A
    assert_respond_to Merchant_A, 'base_url'
    assert_respond_to Merchant_A, 'index_pages'
    assert_respond_to Merchant_A, 'item_css'
    assert_respond_to Merchant_A, 'pager_css'
  end

  class Merchant_BArt; end
  class Merchant_B < Merchant::Base

    self.base_url      = 'http://merchant-b.com'
    self.index_pages   = 'bindex.html'
    self.item_css      = 'b.css'
    self.pager_css     = 'b.pager'
    self.article_model = Merchant_BArt
  end

  def test_should_allow_set_config_options
    assert_equal 'http://merchant-b.com', Merchant_B.base_url
    assert_equal 'bindex.html', Merchant_B.index_pages
    assert_equal 'b.css', Merchant_B.item_css
    assert_equal 'b.pager', Merchant_B.pager_css
  end

  class Merchant_CArticle; end
  class Merchant_C < Merchant::Base
    self.base_url      = 'http://merchant-c.com'
    self.index_pages   = 'cindex.html'
    self.item_css      = 'c.css'
    self.pager_css     = 'c.pager'
    self.article_model = Merchant_CArticle
  end

  def test_merchants_should_not_override_config
    assert Merchant_C.base_url, 'http://merchant-c.com'
    assert Merchant_C.index_pages, 'cindex.html'
    assert Merchant_C.item_css, 'c.css'
    assert Merchant_C.pager_css, 'c.pager'
  end

  def test_merchants_should_have_article_model
    assert_respond_to Merchant_A, 'article_model'
    assert_respond_to Merchant_B, 'article_model'
    assert_respond_to Merchant_C, 'article_model'

    assert_equal Merchant_A.article_model, Article
    assert_equal Merchant_B.article_model, Merchant_BArt
    assert_equal Merchant_C.article_model, Merchant_CArticle
  end
end