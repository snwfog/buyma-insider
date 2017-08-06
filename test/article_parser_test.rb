require_relative './setup'

class ArticleParserTest < Minitest::Test
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

    parser = Class.new do |klazz|
      class << klazz
        def code; 'sse'; end
        def domain; '//www.ssense.com'; end
      end
    end.extend(Merchants::Ssense::Parser)

    article_hash = parser.attrs_from_node(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'Saint Laurent - Tan Canadian Tapestry Coat', article_hash[:description]
    assert_equal 'Tan Canadian Tapestry Coat', article_hash[:name]
    assert_equal 5890.00, ('%.02f' % article_hash[:price].to_f).to_f
    assert_equal 'sse:162418M176009', article_hash[:id]
    assert_equal '//www.ssense.com/en-ca/men/product/saint-laurent/tan-canadian-tapestry-coat/1676753', article_hash[:link]
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

    parser = Class.new do |klazz|
      class << self
        def code; 'zar'; end
        def domain; '//www.zara.com/ca/en'; end
      end
    end.extend(Merchants::Zara::Parser)

    article_hash = parser.attrs_from_node(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li'))
    assert_equal 'Velvet Toggle Jacket', article_hash[:name]
    assert_equal 'Velvet toggle jacket', article_hash[:description]
    assert_equal 139.00, ('%.02f' % article_hash[:price].to_f).to_f
    assert_equal 'zar:3711654', article_hash[:id]
    assert_equal '//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html', article_hash[:link]
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

    parser = Class.new do |klazz|
      class << klazz
        def code; 'get'; end
        def domain; '//www.getoutsideshoes.com'; end
      end
    end.extend(Merchants::Getoutside::Parser)

    article_hash = parser.attrs_from_node(
      Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li')
    )

    assert_equal 'Sperry Waterproof Cold Bay Boot', article_hash[:description]
    assert_equal 'Sperry Waterproof Cold Bay Boot', article_hash[:name]
    assert_equal 179.99, ('%.02f' % article_hash[:price].to_f).to_f
    assert_equal 'get:86405', article_hash[:id]
    assert_equal 'http://www.getoutsideshoes.com/sperry-men-waterproof-cold-bay-boot-tan-gum.html', article_hash[:link]
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

    parser = Class.new do |klazz|
      class << klazz
        def code; 'get'; end
        def domain; '//www.getoutsideshoes.com'; end
      end
    end.extend(Merchants::Getoutside::Parser)
    article_hash = parser.attrs_from_node(
      Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li')
    )

    assert_equal 'Native Apex', article_hash[:description]
    assert_equal 'Native Apex', article_hash[:name]
    assert_equal 119.99, ('%.02f' % article_hash[:price].to_f).to_f
    assert_equal 'get:86297', article_hash[:id]
    assert_equal 'http://www.getoutsideshoes.com/native-men-apex-dublin-grey-shell-white.html', article_hash[:link]
  end

  def test_should_parse_octobersveryown
    frag = <<~FRAG
      <div class="grid__item prod-xlarge--one-fifth prod-large--one-quarter prod-medium--one-half " style="position:relative">
        <a href="/collections/all/products/ovo-athletics-tee-red" class="grid__image">
          <img src="//cdn.shopify.com/s/files/1/0973/7782/products/OVO_ATHLETIC_TEE_SS17_RED_FRONT_large.jpg?v=1492102380" alt="OVO ATHLETICS TEE – RED" title="OVO ATHLETICS TEE – RED">
        </a>
        <p class="h6">
          <a href="/collections/all/products/ovo-athletics-tee-red">OVO ATHLETICS TEE – RED</a>
        </p>
        <p>$40.00</p>
      </div>
    FRAG

    parser = Class.new do |klazz|
      class << klazz
        def code; 'ovo'; end
        def domain; '//ca.octobersveryown.com'; end
      end
    end

    parser.extend(Merchants::Octobersveryown::Parser)
    article_hash = parser
                     .attrs_from_node(
                       Nokogiri::HTML::DocumentFragment
                         .parse(frag)
                         .at_css('div'))

    assert_equal 'Ovo Athletics Tee – Red', article_hash[:name]
    assert_equal 'Ovo athletics tee – red', article_hash[:description]
    assert_equal 40.00, article_hash[:price]
    assert_equal "ovo:#{Digest::MD5.hexdigest('Ovo Athletics Tee – Red'.titleize)}", article_hash[:id]
    assert_equal '//ca.octobersveryown.com/collections/all/products/ovo-athletics-tee-red', article_hash[:link]
  end

  def test_should_parse_livestock
    frag = <<~FRAG
      <div class="four columns omega thumbnail odd">
        <a href="/collections/new-arrivals/products/adidas-womens-alphabounce-1-reigning-champ-white?lshst=collection" title="ADIDAS WOMEN'S ALPHABOUNCE 1 REIGNING CHAMP / WHITE">
          <div class="relative product_image">
            <img style="max-height:275px" src="//cdn.shopify.com/s/files/1/0616/3517/products/cg5329_adidas_womens_alphabounce_1_reigning_champ_white_1_large.jpg?v=1501613111" data-src-retina="//cdn.shopify.com/s/files/1/0616/3517/products/cg5329_adidas_womens_alphabounce_1_reigning_champ_white_1_large.jpg?v=1501613111" alt="style code CG5329. ADIDAS WOMEN'S ALPHABOUNCE 1 REIGNING CHAMP / WHITE">
            <span data-fancybox-href="#product-11326158357" class="quick_shop action_button" data-gallery="product-11326158357-gallery" style="display: none;">
              Quick View
              <div class="overlay" style="position:absolute; width:100%; font-size:10px; background-color:#f2f2f2;padding:8px 0 8px 0;">
                <div class="size-label"></div>
                <div class="size-val">
                  <span value="48109400981" style="color:#242424;float:left;margin:1px 4px 0 0;">5</span>
                  <span value="48109401109" style="color:#242424;float:left;margin:1px 4px 0 0;">6</span>
                  <span value="48109401045" style="color:#242424;float:left;margin:1px 4px 0 0;">6.5</span>
                  <span value="48109400853" style="color:#242424;float:left;margin:1px 4px 0 0;">7</span>
                  <span value="48109400661" style="color:#242424;float:left;margin:1px 4px 0 0;">7.5</span>
                  <span value="48109400725" style="color:#242424;float:left;margin:1px 4px 0 0;">8</span>
                  <span value="48109400789" style="color:#242424;float:left;margin:1px 4px 0 0;">8.5</span>
                  <span value="48109400917" style="color:#242424;float:left;margin:1px 4px 0 0;">9</span>
                </div>
                <div class="free-ship">
                  <span class="free-shipping" style="background:#019444;">
                    FREE SHIPPING
                    <!--                   <img src="//cdn.shopify.com/s/files/1/0616/3517/t/125/assets/free-shipping-banner-small-button.png?16613966375893227151"> -->
                  </span>
                </div>
              </div>
            </span>
          </div>
          <div class="info">
            <div class="sizes_available">
              <span></span>
              <span value="48109400981" class="size">5</span>
              <span value="48109401109" class="size">6</span>
              <span value="48109401045" class="size">6.5</span>
              <span value="48109400853" class="size">7</span>
              <span value="48109400661" class="size">7.5</span>
              <span value="48109400725" class="size">8</span>
              <span value="48109400789" class="size">8.5</span>
              <span value="48109400917" class="size">9</span>
              <br>
              <span class="free-shipping" style="background:#019444;">
                FREE SHIPPING
                <!--                   <img src="//cdn.shopify.com/s/files/1/0616/3517/t/125/assets/free-shipping-banner-small-button.png?16613966375893227151"> -->
              </span>
            </div>
            <span class="title">ADIDAS WOMEN'S ALPHABOUNCE 1 REIGNING CHAMP / WHITE</span>
            <span class="price ">
            <span class="money" data-currency-cad="$160.00 CAD">$160.00 CAD</span>
            </span>
          </div>
        </a>
      </div>
    FRAG

    parser = Class.new do |klass|
      class << klass
        def code; 'ltk'; end
        def domain; '//www.deadstock.ca'; end
      end
    end

    parser.extend(Merchants::Livestock::Parser)
    article_hash = parser
                     .attrs_from_node(
                       Nokogiri::HTML::DocumentFragment
                         .parse(frag)
                         .at_css('div'))

    assert_equal 'Adidas Women\'s Alphabounce 1 Reigning Champ / White', article_hash[:name]
    assert_equal 'Adidas women\'s alphabounce 1 reigning champ / white', article_hash[:description]
    assert_equal 160.00, article_hash[:price]
    assert_equal "ltk:#{Digest::MD5.hexdigest('ADIDAS WOMEN\'S ALPHABOUNCE 1 REIGNING CHAMP / WHITE')}", article_hash[:id]
    assert_equal '//www.deadstock.ca/collections/new-arrivals/products/adidas-womens-alphabounce-1-reigning-champ-white', article_hash[:link]
  end
end