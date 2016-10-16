require 'buyma_insider'
require 'minitest/autorun'

class ArticleTest < Minitest::Test
  def test_should_have_merchant_code
    Article.descendants.each do |c|
      refute_nil c.merchant_code, "#{c} should have merchant code"
      assert c.merchant_code.length == 3, "#{c} should have merchant code of length 3"
      assert c.new.merchant_code.length == 3, "Instance of #{c} should have merchant code of length 3"
    end
  end

  def test_ssense_should_parse
    frag = <<-FRAG
      <div class="browsing-product-item" itemscope="" itemtype="http://schema.org/Product" data-product-id="1676753" data-product-sku="162418M176009" data-product-name="Tan Canadian Tapestry Coat" data-product-brand="Saint Laurent" data-product-price="5890" data-product-category="Coats">
        <meta itemprop="brand" content="Saint Laurent">
        <meta itemprop="name" content="Tan Canadian Tapestry Coat">
        <meta itemprop="image" content="https://res.cloudinary.com/ssenseweb/image/upload/b_white,c_lpad,g_south,h_1086,w_724/c_scale,h_560/v550/162418M176009_1.jpg">
        <meta itemprop="url" content="http://www.ssense.com/en-ca/men/product/saint-laurent/tan-canadian-tapestry-coat/1676753">
        <a data-product-id="1676753" data-product-sku="162418M176009" data-product-brand="Saint Laurent" data-product-name="Tan Canadian Tapestry Coat" data-product-price="5890" data-position="1" data-product-category="Coats" href="/en-ca/men/product/saint-laurent/tan-canadian-tapestry-coat/1676753">
          <div class="browsing-product-thumb-container">
            <div class="browsing-product-thumb">
              <img class="product-thumbnail" src="https://res.cloudinary.com/ssenseweb/image/upload/b_white,c_lpad,g_south,h_1086,w_724/c_scale,h_560/v550/162418M176009_1.jpg" alt="Saint Laurent - Tan Canadian Tapestry Coat">
            </div>
          </div>
          <div class="browsing-product-description text-center vspace1" itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
            <p class="bold">Saint Laurent</p>
            <p class="hidden-smartphone-landscape">Tan Canadian Tapestry Coat</p>
            <p class="price">
              <span class="price">$5890</span>
            </p>
            <meta itemprop="price" content="5890.00">
            <meta itemprop="priceCurrency" content="CAD">
          </div>
        </a>
      </div>
    FRAG

    article = SsenseArticle.attrs_from_node(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'Saint Laurent - Tan Canadian Tapestry Coat', article[:description]
    assert_equal 'Tan Canadian Tapestry Coat', article[:name]
    assert_equal 5890.00, ('%.02f' % article[:price].to_f).to_f
    assert_equal 'sse:162418M176009', article[:id]
    assert_equal '//www.ssense.com/en-ca/men/product/saint-laurent/tan-canadian-tapestry-coat/1676753', article[:link]
  end

  def test_zara_should_parse
    frag = <<-FRAG
      <li id="product-3711654" class="product _product" data-productid="3711654" data-title="">
        <a class="item _item" href="//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html"><img id="product-img-3711654" class="_img _imageLoaded" alt="VELVET TOGGLE JACKET" src="//static.zara.net/photos///2016/I/0/1/p/6895/255/800/2/w/200/6895255800_2_8_1.jpg?ts=1475748298086"></a>
        <div class="product-info">
          <div class="label"><span class="label-New NEW">New</span></div>
          <a class="name _item" href="//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html" aria-hidden="true" tabindex="-1">VELVET TOGGLE JACKET</a>
          <div class="price _product-price"><span data-price="139.00 CAD">139.00 CAD</span></div>
        </div>
      </li>
    FRAG

    article = ZaraArticle.attrs_from_node(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li'))
    assert_equal 'VELVET TOGGLE JACKET', article[:description]
    assert_equal 'VELVET TOGGLE JACKET', article[:name]
    assert_equal 139.00, ('%.02f' % article[:price].to_f).to_f
    assert_equal 'zar:3711654', article[:id]
    assert_equal '//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html', article[:link]
  end
end