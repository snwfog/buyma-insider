require_relative './setup'

class ArticleParserTest < Minitest::Test
  def test_ssense_should_parse
    frag = <<~HTML
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
    HTML

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
    frag = <<~HTML
      <li id="product-3711654" class="product _product" data-productid="3711654" data-title="">
        <a class="item _item" href="//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html"><img id="product-img-3711654" class="_img _imageLoaded" alt="VELVET TOGGLE JACKET" src="//static.zara.net/photos///2016/I/0/1/p/6895/255/800/2/w/200/6895255800_2_8_1.jpg?ts=1475748298086"></a>
        <div class="product-info">
          <div class="label"><span class="label-New NEW">New</span></div>
          <a class="name _item" href="//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html" aria-hidden="true" tabindex="-1">VELVET TOGGLE JACKET</a>
          <div class="price _product-price"><span data-price="139.00 CAD">139.00 CAD</span></div>
        </div>
      </li>
    HTML

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
    frag = <<~HTML
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
    HTML

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
    frag = <<~HTML
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
    HTML

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
    frag = <<~HTML
      <div class="grid__item prod-xlarge--one-fifth prod-large--one-quarter prod-medium--one-half " style="position:relative">
        <a href="/collections/all/products/ovo-athletics-tee-red" class="grid__image">
          <img src="//cdn.shopify.com/s/files/1/0973/7782/products/OVO_ATHLETIC_TEE_SS17_RED_FRONT_large.jpg?v=1492102380" alt="OVO ATHLETICS TEE – RED" title="OVO ATHLETICS TEE – RED">
        </a>
        <p class="h6">
          <a href="/collections/all/products/ovo-athletics-tee-red">OVO ATHLETICS TEE – RED</a>
        </p>
        <p>$40.00</p>
      </div>
    HTML

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
    frag = <<~HTML
      <div class="four columns alpha thumbnail even">
        <a href="/collections/new-arrivals/products/adidas-ultraboost-laceless-legend-ink" title="ADIDAS ULTRABOOST LACELESS / LEGEND INK">
        <div class="relative product_image">
          <img alt="style code S80771. ADIDAS ULTRABOOST LACELESS / LEGEND INK" data-src-retina="//cdn.shopify.com/s/files/1/0616/3517/products/s80771_adidas_ultraboost_laceless_legend_ink_1_large.jpg?v=1503073528" src="//cdn.shopify.com/s/files/1/0616/3517/products/s80771_adidas_ultraboost_laceless_legend_ink_1_large.jpg?v=1503073528" style="max-height:275px"> <span class="quick_shop action_button" data-fancybox-href="#product-10567086869" data-gallery="product-10567086869-gallery">Quick View</span>
          <div class="overlay" style="position:absolute; width:100%; font-size:10px; background-color:#f2f2f2;padding:8px 0 8px 0;">
            <span class="quick_shop action_button" data-fancybox-href="#product-10567086869" data-gallery="product-10567086869-gallery"></span>
            <div class="size-label">
              <span class="quick_shop action_button" data-fancybox-href="#product-10567086869" data-gallery="product-10567086869-gallery"></span>
            </div>
            <div class="size-val">
              <span class="quick_shop action_button" data-fancybox-href="#product-10567086869" data-gallery="product-10567086869-gallery"><span style="color:#242424;float:left;margin:1px 4px 0 0;">7</span> <span style="text-decoration: line-through; color:#f06c6c;float:left;margin:1px 4px 0 0;">7.5</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">8</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">8.5</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">9</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">9.5</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">10</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">10.5</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">11</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">11.5</span> <span style="color:#242424;float:left;margin:1px 4px 0 0;">12</span> <span style="text-decoration: line-through; color:#f06c6c;float:left;margin:1px 4px 0 0;">13</span></span>
            </div>
            <div class="free-ship">
              <span class="free-shipping" style="background:#019444;">FREE SHIPPING <!--                   <img src="//cdn.shopify.com/s/files/1/0616/3517/t/127/assets/free-shipping-banner-small-button.png?1039608231286475540"> --></span>
            </div>
          </div>
        </div>
        <div class="info">
          <div class="sizes_available">
            <span></span> <span class="size">7</span> <span class="size is-unavailable">7.5</span> <span class="size">8</span> <span class="size">8.5</span> <span class="size">9</span> <span class="size">9.5</span> <span class="size">10</span> <span class="size">10.5</span> <span class="size">11</span> <span class="size">11.5</span> <span class="size">12</span> <span class="size is-unavailable">13</span><br>
            <span class="free-shipping" style="background:#019444;">FREE SHIPPING <!--                   <img src="//cdn.shopify.com/s/files/1/0616/3517/t/127/assets/free-shipping-banner-small-button.png?1039608231286475540"> --></span>
          </div><span class="title">ADIDAS ULTRABOOST LACELESS / LEGEND INK</span> <span class="price"><span class="money">$250.00 CAD</span></span>
        </div></a>
      </div>
    HTML

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

    assert_equal 'Adidas Ultraboost Laceless / Legend Ink', article_hash[:name]
    assert_equal 'Adidas ultraboost laceless / legend ink', article_hash[:description]
    assert_equal 250.00, article_hash[:price]
    assert_equal "#{Digest::MD5.hexdigest('adidas ultraboost laceless / legend ink')}", article_hash[:sku]
    assert_equal '//www.deadstock.ca/collections/new-arrivals/products/adidas-ultraboost-laceless-legend-ink', article_hash[:link]
  end

  def test_should_parse_canada_goose
    frag = <<~HTML
      <div class="product-tile" data-cgid="shop-mens" data-itemid="6930M" id="f4d200e5722a6b62e5151f8c92">
        <!-- dwMarker="product" dwContentID="f4d200e5722a6b62e5151f8c92" -->
        <div class="product-image">
          <!-- dwMarker="product" dwContentID="f4d200e5722a6b62e5151f8c92" -->
          <a class="thumb-link" href="/ca/en/hybridge-knit-jacket-6930M.html?cgid=shop-mens" title="HyBridge Knit Jacket"><img alt="HyBridge Knit Jacket" class="one-img" src="http://demandware.edgesuite.net/sits_pod15/dw/image/v2/AATA_PRD/on/demandware.static/-/Sites-canadagoose-master-catalog/default/dw0b058e38/images/productimages/6930M_67.jpg?sw=435&amp;sh=655&amp;sm=fit" style="display: block;" title="HyBridge Knit Jacket"> <input class="secondImage" type="hidden" value="true"> <input class="deviceType" type="hidden" value="null"> <img alt="HyBridge Knit Jacket" class="two-img" src="http://demandware.edgesuite.net/sits_pod15/dw/image/v2/AATA_PRD/on/demandware.static/-/Sites-canadagoose-master-catalog/default/dwc896ccc1/images/productimages/6930M_67_a.jpg?sw=435&amp;sh=655&amp;sm=fit" style="display: none;" title="HyBridge Knit Jacket"></a>
          <div class="badge-container"><img class="badge" src="http://demandware.edgesuite.net/aata_prd/on/demandware.static/-/Library-Sites-CG-Global/default/dwc669adcc/images/badges/badge-new-style.png"></div>
        </div>
        <div class="product-name">
          <a class="name-link" href="/ca/en/hybridge-knit-jacket-6930M.html" title="HyBridge Knit Jacket">HyBridge Knit Jacket</a>
        </div>
        <div class="product-pricing">
          <div class="product-price" itemprop="offers" itemscope itemtype="https://schema.org/Offer">
            <span class="microdata visually-hidden"></span>
            <link href="http://schema.org/InStock" itemprop="availability"><span class="price-sales"><span content="CAD" itemprop="priceCurrency"></span> <span content="595.00" itemprop="price">$595.00</span></span> <input id="currency" type="hidden" value="$">
          </div>
        </div>
        <div class="product-promo"></div>
        <div class="product-swatches">
          <ul class="swatch-list">
            <li>
              <a class="swatch" title="Black">
              <div class="image-outer">
                <div class="image-inner1"><img alt="" class="swatch-image" data-thumb="{&quot;src&quot;:&quot;http://demandware.edgesuite.net/sits_pod15/dw/image/v2/AATA_PRD/on/demandware.static/-/Sites-canadagoose-master-catalog/default/dw4e204706/images/productimages/6930M_61.jpg?sw=435&amp;sh=655&amp;sm=fit&quot;,&quot;alt&quot;:&quot;HyBridge Knit Jacket&quot;,&quot;title&quot;:&quot;HyBridge Knit Jacket&quot;}" src="http://demandware.edgesuite.net/aata_prd/on/demandware.static/-/Library-Sites-CG-Global/default/dw466c9277/images/swatch/61.svg"></div>
              </div></a>
            </li>
            <li>
              <a class="swatch" title="Navy">
              <div class="image-outer">
                <div class="image-inner1"><img alt="" class="swatch-image" data-thumb="{&quot;src&quot;:&quot;http://demandware.edgesuite.net/sits_pod15/dw/image/v2/AATA_PRD/on/demandware.static/-/Sites-canadagoose-master-catalog/default/dw0b058e38/images/productimages/6930M_67.jpg?sw=435&amp;sh=655&amp;sm=fit&quot;,&quot;alt&quot;:&quot;HyBridge Knit Jacket&quot;,&quot;title&quot;:&quot;HyBridge Knit Jacket&quot;}" src="http://demandware.edgesuite.net/aata_prd/on/demandware.static/-/Library-Sites-CG-Global/default/dw733c023b/images/swatch/67.svg"></div>
              </div></a>
            </li>
          </ul><!-- .swatch-list -->
        </div><!-- .product-swatches -->
      </div>
    HTML

    parser = Class.new do |klass|
      class << klass
        def code; 'goo'; end
        def domain; '//www.canadagoose.com'; end
      end
    end

    parser.extend(Merchants::CanadaGoose::Parser)
    article_hash = parser
                     .attrs_from_node(
                       Nokogiri::HTML::DocumentFragment
                         .parse(frag)
                         .at_css('div'))

    assert_equal 'HyBridge Knit Jacket', article_hash[:name]
    assert_equal 'HyBridge Knit Jacket', article_hash[:description]
    assert_equal '595.00', article_hash[:price]
    assert_equal 'f4d200e5722a6b62e5151f8c92', article_hash[:sku]
    assert_equal '//www.canadagoose.com/ca/en/hybridge-knit-jacket-6930M.html', article_hash[:link]
  end

  def test_should_parse_arcteryx
    frag = <<~HTML
      <div class="searchResult Shell_Jackets" data-baseimage="Gamma-MX-Hoody" data-black="Blackbird" data-blue="Rigel" data-drag-drop-image="//images.arcteryx.com/F17/85x110/Gamma-MX-Hoody-Pompeii.png" data-grey="Heron" data-model="19274" data-red="Pompeii" id="Gamma-MX-Hoody">
        <a class="Shell_Jackets" href="product.aspx?country=ca&amp;language=en&amp;gender=mens&amp;model=Gamma-MX-Hoody">
          <span class="searchResultThumbnail" id="Gamma-MX-Hoody_Thumbnail">
            <span class="viewProduct">
              <span class="viewProductCta">Shop Now</span>
            </span>
            <img alt="Gamma MX Hoody Men's" data-image-alt="//images.arcteryx.com/details/450x500/Gamma-MX-Hoody-Pompeii-Open-Collar.jpg" src="//images.arcteryx.com/F17/162x205/Gamma-MX-Hoody-Pompeii.gif"></span> <span class="searchResultColours" id="Gamma-MX-Hoody_Colours">
            <span class="spanSearchResultColoursList">
              <span class="spanSearchResultColoursListItem BLACK" data-basecolour="BLACK" data-colourname="Blackbird" style="background: #333333;">Blackbird</span> 
              <span class="spanSearchResultColoursListItem GREY" data-basecolour="GREY" data-colourname="Heron" style="background: #5B6173;">Heron</span> 
              <span class="spanSearchResultColoursListItem RED selected" data-basecolour="RED" data-colourname="Pompeii" style="background: #98382f;">Pompeii</span> 
              <span class="spanSearchResultColoursListItem BLUE" data-basecolour="BLUE" data-colourname="Rigel" style="background: #2a6be1;">Rigel</span> 
            </span>
          </span>
          <span class="BVRRRatingSummary">
            <img alt="4.55 / 5" class="BVImgOrSprite" src="//arcteryx.ugc.bazaarvoice.com/7059-en_ca/4_55/5/rating.gif" title="4.55 / 5">
            <span class="BVRRNumber">56</span> Reviews
          </span>
          <span class="searchResultName" id="Gamma-MX-Hoody_Name">Gamma MX Hoody Men's
            <span class="subMarketName">Lightly insulated, softshell alpine hoody, with stretch for mixed weather.</span>
          </span> 
          <span class="searchResultPrice" id="Gamma-MX-Hoody_Price">$400.00</span> 
          <span class="searchResultCrncy" id="Gamma-MX-Hoody_Crncy">CAD</span>
          <span class="description">Breathable, wind-resistant, lightly insulated hooded jacket constructed with Fortius 2.0 textile for increased comfort and mobility. Gamma Series: Softshell outerwear with stretch | MX: Mixed Weather.</span>
        </a> 
        <label class="compare-checkbox">
          <input name="compare" type="checkbox" value="19274">
          <span class="compare-checkbox-label">Compare Products</span>
        </label>
      </div>
    HTML

    parser = Class.new do |klass|
      class << klass
        def code; 'arc'; end
        def domain; '//arcteryx.com'; end
      end
    end

    parser.extend(Merchants::Arcteryx::Parser)
    article_hash = parser.attrs_from_node(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))

    assert_equal 'Gamma MX Hoody Men\'s', article_hash[:name]
    assert_equal 'Breathable, wind-resistant, lightly insulated hooded jacket constructed with Fortius 2.0 textile for increased comfort and mobility. Gamma Series: Softshell outerwear with stretch | MX: Mixed Weather.', article_hash[:description]
    assert_equal '400.00', article_hash[:price]
    assert_equal '19274', article_hash[:sku]
    assert_equal '//arcteryx.com/product.aspx?country=ca&language=en&gender=mens&model=Gamma-MX-Hoody', article_hash[:link]
  end
end