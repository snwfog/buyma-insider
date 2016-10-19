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

  def test_should_all_have_unique_merchant_code
    merchant_codes = Article.descendants.map(&:merchant_code)
    assert_equal merchant_codes.uniq.sort.to_s, merchant_codes.sort.to_s
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

  def test_getoutside_should_parse
    frag = <<-FRAG
      <li class="item">
        <div class="product-image-wrapper">
          <a href="http://www.getoutsideshoes.com/sperry-men-waterproof-cold-bay-boot-tan-gum.html" title="Sperry Waterproof Cold Bay Boot" class="product-image">
            <img src="http://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/1/0/1018-sperry-mens-cold-bay-tan-sts14383.jpg" alt="Sperry Waterproof Cold Bay Boot">
            <span class="sticker-wrapper top-left"><span class="sticker new">New</span></span>
          </a>
          <ul class="add-to-links clearer addto-links-icons addto-onimage display-onhover" style="display: none;">
            <li>
              <a class="link-wishlist" rel="nofollow" href="https://www.getoutsideshoes.com/wishlist/index/add/product/86405/form_key/uBsA0J7tsGSdqjdY/" title="Add to Wishlist">
              <span class="icon icon-hover i-wishlist-bw"></span>
              </a>
            </li>
          </ul>
        </div>
        <h2 class="product-name">
            <a href="http://www.getoutsideshoes.com/sperry-men-waterproof-cold-bay-boot-tan-gum.html" title="Sperry Waterproof Cold Bay Boot">Sperry Waterproof Cold Bay Boot</a>
        </h2>
        <div class="price-box">
          <span class="regular-price" id="product-price-86405"><span class="price">CA$ 179.99</span></span>
        </div>
        <div class="actions clearer"></div>
      </li>
    FRAG

    article = GetoutsideArticle.attrs_from_node(
      Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li')
    )

    assert_equal 'Sperry Waterproof Cold Bay Boot', article[:description]
    assert_equal 'Sperry Waterproof Cold Bay Boot', article[:name]
    assert_equal 179.99, ('%.02f' % article[:price].to_f).to_f
    assert_equal 'get:86405', article[:id]
    assert_equal 'http://www.getoutsideshoes.com/sperry-men-waterproof-cold-bay-boot-tan-gum.html', article[:link]
  end

  def test_getoutside_should_parse_2
    frag = <<-FRAG
      <li class="item">
        <div class="product-image-wrapper" style="max-width:295px;">
          <a href="http://www.getoutsideshoes.com/native-men-apex-dublin-grey-shell-white.html" title="Native Apex" class="product-image">
          <img src="http://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/2/0/208-native-apex-36001453-dublin-grey-1.jpg" alt="Native Apex">
          <img class="alt-img" src="http://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/2/0/208-native-apex-36001453-dublin-grey-2.jpg" alt="Native Apex">
          <span class="sticker-wrapper top-right"><span class="sticker sale">Sale</span></span>                    </a>
          <ul class="add-to-links clearer addto-links-icons addto-onimage display-onhover">
            <li><a class="link-wishlist" rel="nofollow" href="https://www.getoutsideshoes.com/wishlist/index/add/product/86297/form_key/KAG0e9eTWKcI0jsI/" title="Add to Wishlist">
              <span class="icon icon-hover i-wishlist-bw"></span>
              </a>
            </li>
          </ul>
        </div>
        <!-- end: product-image-wrapper -->
        <h2 class="product-name"><a href="http://www.getoutsideshoes.com/native-men-apex-dublin-grey-shell-white.html" title="Native Apex">Native Apex</a></h2>
        <div class="price-box">
          <p class="old-price">
            <span class="price-label">Regular Price:</span>
            <span class="price" id="old-price-86297">
            CA$ 164.99                </span>
          </p>
          <p class="special-price sp-price-line">
            <span class="price" id="product-price-86297">
            CA$ 119.99                </span>
          </p>
        </div>
        <div class="actions clearer">
        </div>
        <!-- end: actions -->
      </li>
    FRAG

    article = GetoutsideArticle.attrs_from_node(
      Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li')
    )

    assert_equal 'Native Apex', article[:description]
    assert_equal 'Native Apex', article[:name]
    assert_equal 119.99, ('%.02f' % article[:price].to_f).to_f
    assert_equal 'get:86297', article[:id]
    assert_equal 'http://www.getoutsideshoes.com/native-men-apex-dublin-grey-shell-white.html', article[:link]
  end

  def test_shoeme_should_parse
    frag = <<-FRAG
      <li class="product-li">
        <div class="product-tile">
          <a href="//shoeme.ecomm-nav.com/redirect?url=http%3A%2F%2Fwww.shoeme.ca%2Fproducts%2Fnorthface-thermoball-roll-down-bootie-ii-tnf-black-jumbo-hbone-print-plum-kittn-gry-cm88" onmousedown="return nxt_repo.product_x('The-North-Face-Womens-Thermoball-Roll-Down-Bootie-II-Tnf-Black-Jumbo-Hbone-Print-plum-Kittn-Gry',13);">
            <img class="product-img img-responsive" src="https://cdn.shopify.com/s/files/1/0121/3322/products/CM88_DUL_SHOE_hero_F15_RGB_3370b15e-c23f-4c2a-8549-3ad10f8cb251_medium.jpeg?v=1450122887" onerror="this.style.display='none';">
          </a>
          <div class="product-dts">
            <div class="product-title">
              <a href="//shoeme.ecomm-nav.com/redirect?url=http%3A%2F%2Fwww.shoeme.ca%2Fproducts%2Fnorthface-thermoball-roll-down-bootie-ii-tnf-black-jumbo-hbone-print-plum-kittn-gry-cm88" onmousedown="return nxt_repo.product_x('The-North-Face-Womens-Thermoball-Roll-Down-Bootie-II-Tnf-Black-Jumbo-Hbone-Print-plum-Kittn-Gry',13);">
                <h5>The North Face</h5>
                <h6>
                  Thermoball Roll-Down Bootie II
                  <span>Black</span>
                </h6>
              </a>
            </div>
            <div class="product-buttons">
              <a href="#" data-wishlist="add"><i class="sm-bag"></i></a>
              <a href="#" data-cart="add"><i class="sm-heart"></i></a>
            </div>
          </div>
          <div class="product-price">
            <p class="product-price">$125.00</p>
          </div>
          <div class="sm-localfulfill" data-lf-vendor="V00018"></div>
        </div>
      </li>
    FRAG

    article = ShoemeArticle.attrs_from_node(
      Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li')
    )

    assert_equal 'The North Face - Thermoball Roll-Down Bootie II', article[:name]
    assert_equal 'The North Face - Thermoball Roll-Down Bootie II', article[:description]
    assert_equal 125.00, ('%.02f' % article[:price].to_f).to_f
    assert_equal "sho:#{Digest::MD5.hexdigest('The North Face - Thermoball Roll-Down Bootie II')}", article[:id]
    assert_equal '//shoeme.ecomm-nav.com/redirect?url=http%3A%2F%2Fwww.shoeme.ca%2Fproducts%2Fnorthface-thermoball-roll-down-bootie-ii-tnf-black-jumbo-hbone-print-plum-kittn-gry-cm88', article[:link]
  end
end