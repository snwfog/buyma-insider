require_relative './setup'

class MerchantExtractAttrsTest < Minitest::Test
  def test_should_extract_attrs_ssense
    frag = <<~HTML
      <figure class="browsing-product-item" itemscope="itemscope" itemtype="http://schema.org/Product">
        <meta content="172342M176002" itemprop="sku">
        <meta content="https://res-5.cloudinary.com/ssenseweb/image/upload/w_1024,dpr_1.0/f_auto/172342M176002_1.jpg" itemprop="image">
        <meta content="https://www.ssense.com/men/product/balenciaga/black-kering-padded-raincoat/2185587" itemprop="url"><a href="/en-ca/men/product/balenciaga/black-kering-padded-raincoat/2185587">
        <div class="image-container">
          <picture data-v-2737e8bc=""><!----><!----><img alt="Balenciaga - Black &#x27;Kering&#x27; Padded Raincoat" class="product-thumbnail lazyload" data-srcset="https://res-5.cloudinary.com/ssenseweb/image/upload/b_white,c_lpad,g_south,h_706,w_470/c_scale,h_280/f_auto,dpr_1.0/v550/172342M176002_1.jpg" data-v-2737e8bc="" src="https://res.cloudinary.com/ssenseweb/image/upload/v1472069180/product-placeholder_qulza9.png"></picture>
        </div>
        <figcaption class="browsing-product-description text-center vspace1">
          <p class="bold" itemprop="brand">Balenciaga</p>
          <p class="hidden-smartphone-landscape" itemprop="name">Black &#x27;Kering&#x27; Padded Raincoat</p><span itemprop="offers" itemscope="itemscope" itemtype="http://schema.org/Offer"></span>
          <meta content="2740" itemprop="price">
          <meta content="CAD" itemprop="priceCurrency">
        </figcaption><!----></a>
        <div>
          <p class="price"><span class="price">$2740</span><!----></p>
        </div>
      </figure>
    HTML

    merchant = MockMerchant.new('sse', '//www.ssense.com')
    merchant.extend(Merchants::Ssense)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('figure'))
    assert_equal 'black \'kering\' padded raincoat', article_hash[:name]
    assert_equal 'Balenciaga - Black \'kering\' padded raincoat', article_hash[:description]
    assert_equal '2740', article_hash[:price]
    assert_equal '172342M176002', article_hash[:sku]
    assert_equal '//www.ssense.com/men/product/balenciaga/black-kering-padded-raincoat/2185587', article_hash[:link]
  end

  def test_should_extract_attrs_zara
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

    merchant = MockMerchant.new('zar', '//www.zara.com/ca/en')
    merchant.extend(Merchants::Zara)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li'))
    assert_equal 'velvet toggle jacket', article_hash[:name]
    assert_equal 'Velvet toggle jacket', article_hash[:description]
    assert_equal '139.00', article_hash[:price]
    assert_equal '3711654', article_hash[:sku]
    assert_equal '//www.zara.com/ca/en/woman/new-in/velvet-toggle-jacket-c840002p3711654.html', article_hash[:link]
  end

  def test_should_extract_attrs_getoutside
    frag = <<~HTML
      <li class="item">
        <div class="product-image-wrapper" style="max-width:295px;">
          <a class="product-image" href="https://www.getoutsideshoes.com/reebok-women-pastel-classic-leather-pink-sneakers-94481.html" title="Reebok Women's Metallic Classic Leather"><img alt="Reebok Women's Metallic Classic Leather" src="https://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/r/e/reebok-women-metallic-classic-leather-peach-bs7897-1.jpg"> <img alt="Reebok Women's Metallic Classic Leather" class="alt-img" src="https://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/r/e/reebok-women-metallic-classic-leather-peach-bs7897-2.jpg"> <span class="sticker-wrapper top-left"><span class="sticker new">New</span></span></a>
          <ul class="add-to-links clearer addto-links-icons addto-onimage display-onhover">
            <li>
              <a class="link-wishlist" href="https://www.getoutsideshoes.com/wishlist/index/add/product/94342/form_key/k5R5Ot3SZhbTpLjl/" rel="nofollow" title="Add to Wishlist"><span class="icon icon-hover i-wishlist-bw"></span></a>
            </li>
          </ul>
        </div><!-- end: product-image-wrapper -->
        <h2 class="product-name"><a href="https://www.getoutsideshoes.com/reebok-women-pastel-classic-leather-pink-sneakers-94481.html" title="Reebok Women's Metallic Classic Leather">Reebok Women's Metallic Classic Leather</a></h2>
        <div class="price-box">
          <span class="regular-price" id="product-price-94342"><span class="price">CAD$ 109.99</span></span>
        </div>
        <div class="actions clearer"></div><!-- end: actions -->
      </li>
    HTML

    merchant = MockMerchant.new('get', '//www.getoutsideshoes.com')
    merchant.extend(Merchants::Getoutside)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li'))
    assert_equal 'reebok women\'s metallic classic leather', article_hash[:name]
    assert_equal 'Reebok women\'s metallic classic leather', article_hash[:description]
    assert_equal '109.99', article_hash[:price]
    assert_equal '94342', article_hash[:sku]
    assert_equal '//www.getoutsideshoes.com/reebok-women-pastel-classic-leather-pink-sneakers-94481.html', article_hash[:link]
  end

  def test_should_extract_attrs_getoutside_with_discount
    frag = <<~HTML
      <li class="item">
        <div class="product-image-wrapper" style="max-width:295px;">
          <a class="product-image" href="https://www.getoutsideshoes.com/converse-kids-chuck-taylor-all-star-hi-soar-93171.html" title="Converse Kids Chuck Taylor All Star Fresh HI"><img alt="Converse Kids Chuck Taylor All Star Fresh HI" src="https://www.getoutsideshoes.com/media/catalog/product/cache/1/small_image/295x295/9df78eab33525d08d6e5fb8d27136e95/c/o/converse-kids-chuck-taylor-fresh-yellow-355738-1.jpg"> <span class="sticker-wrapper top-right"><span class="sticker sale">Sale</span></span></a>
          <ul class="add-to-links clearer addto-links-icons addto-onimage display-onhover">
            <li>
              <a class="link-wishlist" href="https://www.getoutsideshoes.com/wishlist/index/add/product/93078/form_key/obiEJ3xVXq2OOYbs/" rel="nofollow" title="Add to Wishlist"><span class="icon icon-hover i-wishlist-bw"></span></a>
            </li>
          </ul>
        </div><!-- end: product-image-wrapper -->
        <h2 class="product-name"><a href="https://www.getoutsideshoes.com/converse-kids-chuck-taylor-all-star-hi-soar-93171.html" title="Converse Kids Chuck Taylor All Star Fresh HI">Converse Kids Chuck Taylor All Star Fresh HI</a></h2>
        <div class="price-box">
          <p class="old-price"><span class="price-label">Regular Price:</span> <span class="price" id="old-price-93078">CAD$ 39.99</span></p>
          <p class="special-price sp-price-line"><span class="price" id="product-price-93078">CAD$ 24.99</span></p>
        </div>
        <div class="actions clearer"></div><!-- end: actions -->
      </li>
    HTML

    merchant = MockMerchant.new('get', '//www.getoutsideshoes.com')
    merchant.extend(Merchants::Getoutside)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('li'))
    assert_equal 'converse kids chuck taylor all star fresh hi', article_hash[:name]
    assert_equal 'Converse kids chuck taylor all star fresh hi', article_hash[:description]
    assert_equal '24.99', article_hash[:price]
    assert_equal '93078', article_hash[:sku]
    assert_equal '//www.getoutsideshoes.com/converse-kids-chuck-taylor-all-star-hi-soar-93171.html', article_hash[:link]
  end

  def test_should_extract_attrs_octobersveryown
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

    merchant = MockMerchant.new('ovo', '//ca.octobersveryown.com')
    merchant.extend(Merchants::Octobersveryown)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'ovo athletics tee - red', article_hash[:name]
    assert_equal 'Ovo athletics tee - red', article_hash[:description]
    assert_equal '40.00', article_hash[:price]
    assert_equal Digest::MD5.hexdigest(article_hash[:name]), article_hash[:sku]
    assert_equal '//ca.octobersveryown.com/collections/all/products/ovo-athletics-tee-red', article_hash[:link]
  end

  def test_should_extract_attrs_livestock
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

    merchant = MockMerchant.new('ltk', '//www.deadstock.ca')
    merchant.extend(Merchants::Livestock)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'adidas ultraboost laceless / legend ink', article_hash[:name]
    assert_equal 'Adidas ultraboost laceless / legend ink', article_hash[:description]
    assert_equal '250.00', article_hash[:price]
    assert_equal "#{Digest::MD5.hexdigest(article_hash[:name])}", article_hash[:sku]
    assert_equal '//www.deadstock.ca/collections/new-arrivals/products/adidas-ultraboost-laceless-legend-ink', article_hash[:link]
  end

  def test_should_extract_attrs_canada_goose
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

    merchant = MockMerchant.new('goo', '//www.canadagoose.com')
    merchant.extend(Merchants::CanadaGoose)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'HyBridge Knit Jacket', article_hash[:name]
    assert_equal 'HyBridge Knit Jacket', article_hash[:description]
    assert_equal '595.00', article_hash[:price]
    assert_equal 'f4d200e5722a6b62e5151f8c92', article_hash[:sku]
    assert_equal '//www.canadagoose.com/ca/en/hybridge-knit-jacket-6930M.html', article_hash[:link]
  end

  def test_should_extract_attrs_arcteryx
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

    merchant = MockMerchant.new('arc', '//arcteryx.com')
    merchant.extend(Merchants::Arcteryx)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'Gamma MX Hoody Men\'s', article_hash[:name]
    assert_equal 'Breathable, wind-resistant, lightly insulated hooded jacket constructed with Fortius 2.0 textile for increased comfort and mobility. Gamma Series: Softshell outerwear with stretch | MX: Mixed Weather.', article_hash[:description]
    assert_equal '400.00', article_hash[:price]
    assert_equal '19274', article_hash[:sku]
    assert_equal '//arcteryx.com/product.aspx?country=ca&language=en&gender=mens&model=Gamma-MX-Hoody', article_hash[:link]
  end

  def test_should_extract_attrs_adidas_canada
    frag = <<~HTML
      <div class="hockeycard performance" data-colorid="CR6203" data-component="" data-context="sku:CR6203;size:;colors:Dark Blue" data-scope="CR6203" data-target="CR6203" data-url="http://www.adidas.ca/on/demandware.store/Sites-adidas-CA-Site/en_CA/Product-GetVariations?pid=PRODUCTID" id="product-CR6203" style="z-index: 0;">
        <div class="hidden" data-context="category:Clothing;brand:Performance;gender:MEN;type:Hockey;model_id:ZY906;video:OFF;color:Dark Blue;pricebook:adidas-CA-listprices;sport:Hockey"></div>
        <div class="checkbox compare hidden CR6203" data-product-id="CR6203">
          <span class="compare-title">Compare</span>
        </div>
        <div class="innercard">
          <div class="close-container">
            <a class="close close-button" tabindex="-1"></a>
          </div><span class="aditype"></span>
          <div class="badge new">
            <span class="badge-text">New</span>
          </div><a class="add-to-wishlist hockeycard-add-to-wishlist" data-in-wishlist="false" data-masterid="CR6203" href="#"><span class="wishlist-icon"></span></a>
          <div class="image plp-image-bg">
            <a class="link-CR6203 plp-image-bg-link lazybg_loaded" data-component="" data-productname="Men's Maple Leafs Jersey Tee-Matthews" data-track="CR6203" href="http://www.adidas.ca/en/mens-maple-leafs-jersey-tee-matthews/CR6203.html"><img alt="adidas - Men's Maple Leafs Jersey Tee-Matthews Dark Blue CR6203" class="show lazyload" data-original="http://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw821a9ea9/zoom/CR6203_02_laydown.jpg?sw=230&amp;sfrm=jpg" data-othermobileview="http://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw821a9ea9/zoom/CR6203_02_laydown.jpg?sw=230&amp;sfrm=jpg" data-stackmobileview="http://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw821a9ea9/zoom/CR6203_02_laydown.jpg?sw=280&amp;sfrm=jpg" height="230" src="http://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw821a9ea9/zoom/CR6203_02_laydown.jpg?sw=230&amp;sfrm=jpg" title="adidas - Men's Maple Leafs Jersey Tee-Matthews" width="230"></a>
          </div>
          <div class="product-info-wrapper stack track" data-context="article:CR6203" data-track="plp product">
            <div class="product-info-inner clear clearfix">
              <div class="color-count spacer">
                &nbsp;
              </div>
            </div>
            <div class="hc-separator line-dotted-light divider-hor-top"></div>
            <div class="product-info-inner-content clearfix with-badges">
              <a class="link-CR6203 product-link clearfix" data-context="name:Men's Maple Leafs Jersey Tee-Matthews" data-productname="Men's Maple Leafs Jersey Tee-Matthews" data-track="CR6203" href="http://www.adidas.ca/en/mens-maple-leafs-jersey-tee-matthews/CR6203.html" tabindex="-1"><span class="title">Men's Maple Leafs Jersey Tee-Matthews</span> <span class="subtitle">Men Hockey</span></a>
            </div>
            <div class="clearfix product-info-price-rating price-without-rating">
              <div class="price" data-context="price:38.00; price_vat:38; price_type:full price">
                <span class="currency-sign">C$</span> <span class="salesprice" id="salesprice-CR6203_380">38</span>
              </div>
            </div>
            <div class="buttons clearfix" data-context="status:IN STOCK">
              <div class="button-container" id="CR6203-buttons"></div>
              <div class="cartaction" id="CR6203-cartaction"></div>
              <div class="add-to-cart button-atb button-full-width cart-loading button-loading" id="CR6203-loading">
                <span class="text">Add To Bag</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    HTML

    merchant = MockMerchant.new('add', '//www.adidas.ca')
    merchant.extend(Merchants::AdidasCanada)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'men\'s maple leafs jersey tee-matthews', article_hash[:name]
    assert_equal 'Men\'s maple leafs jersey tee-matthews', article_hash[:description]
    assert_equal '38.00', article_hash[:price]
    assert_equal 'CR6203', article_hash[:sku]
    assert_equal '//www.adidas.ca/en/mens-maple-leafs-jersey-tee-matthews/CR6203.html', article_hash[:link]
  end

  def test_should_extract_attrs_adidas_canada_with_discount
    frag = <<~HTML
      <div class="hockeycard athletics" data-colorid="B49913" data-component="" data-context="sku:B49913;size:;colors:Core Heather/Black;genders:" data-scope="B49913" data-target="B49913" data-url="https://www.adidas.ca/on/demandware.store/Sites-adidas-CA-Site/en_CA/Product-GetVariations?pid=PRODUCTID" id="product-B49913">
        <div class="hidden" data-context="category:Clothing;brand:Athletics;gender:MEN;type:;model_id:BUQ98;video:OFF;color:Core Heather/Black;pricebook:adidas-CA-listprices;sport:Lifestyle|Training"></div>
        <div class="checkbox compare hidden B49913" data-product-id="B49913">
          <span class="compare-title">Compare</span>
        </div>
        <div class="innercard">
          <div class="close-container">
            <a class="close close-button" tabindex="-1"></a>
          </div><span class="aditype"></span>
          <div class="badge sale">
            <span class="badge-text">-15 %</span>
          </div><a class="add-to-wishlist hockeycard-add-to-wishlist" data-in-wishlist="false" data-masterid="B49913" href="#"><span class="wishlist-icon"></span></a>
          <div class="image plp-image-bg">
            <a class="product-images-js link-B49913 plp-image-bg-link" data-component="productlist/ProductImage" data-productname="Men's Sport Essentials French Terry Hoodie" data-track="B49913" href="http://www.adidas.ca/en/mens-sport-essentials-french-terry-hoodie/B49913.html"><img alt="adidas - Men's Sport Essentials French Terry Hoodie Core Heather/Black B49913" class="show lazyload" data-original="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dwfe4cd3b1/zoom/B49913_000_plp_model.jpg?sw=230&amp;sfrm=jpg" data-othermobileview="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dwfe4cd3b1/zoom/B49913_000_plp_model.jpg?sw=230&amp;sfrm=jpg" data-stackmobileview="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dwfe4cd3b1/zoom/B49913_000_plp_model.jpg?sw=280&amp;sfrm=jpg" height="230" src="https://www.adidas.ca/static/on/demandware.static/Sites-adidas-CA-Site/-/default/dw56d45f8a/images/1x1.gif" title="adidas - Men's Sport Essentials French Terry Hoodie" width="230"> <img alt="adidas - Men's Sport Essentials French Terry Hoodie Core Heather/Black B49913" class="hide lazyload loadonhover not-loaded" data-original="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw2cc4e8c7/zoom/B49913_23_hover_model.jpg?sw=230&amp;sfrm=jpg" data-othermobileview="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw2cc4e8c7/zoom/B49913_23_hover_model.jpg?sw=230&amp;sfrm=jpg" data-stackmobileview="https://www.adidas.ca/dis/dw/image/v2/aaqx_prd/on/demandware.static/-/Sites-adidas-products/default/dw2cc4e8c7/zoom/B49913_23_hover_model.jpg?sw=280&amp;sfrm=jpg" height="230" title="adidas - Men's Sport Essentials French Terry Hoodie" width="230"></a>
          </div>
          <div class="product-info-wrapper stack track" data-context="article:B49913" data-track="plp product">
            <div class="product-info-inner clear clearfix">
              <div class="color-count spacer">
                &nbsp;
              </div>
            </div>
            <div class="hc-separator line-dotted-light divider-hor-top"></div>
            <div class="product-info-inner-content clearfix with-badges">
              <a class="link-B49913 product-link clearfix" data-context="name:Men's Sport Essentials French Terry Hoodie" data-productname="Men's Sport Essentials French Terry Hoodie" data-track="B49913" href="http://www.adidas.ca/en/mens-sport-essentials-french-terry-hoodie/B49913.html" tabindex="-1"><span class="title">Men&#39;s Sport Essentials French Terry Hoodie</span> <span class="subtitle">Men Athletics</span></a>
            </div>
            <div class="clearfix product-info-price-rating">
              <div class="price" data-context="price:64.95; price_vat:65; price_type:on sale">
                <span class="currency-sign currency-sign-discounted">C$</span> <span class="salesprice discount-price" id="salesprice-B49913_310">64.95</span> <span class="strike"><span class="currency">C$</span> <span class="baseprice" id="baseprice-B49913_310">80</span></span>
              </div>
              <div class="rating new-plp-layout-disabled" data-context="rating:5;reviews:7">
                <!-- rating -->
                <div class="rating-stars-container">
                  <ul class="rating-stars rating-stars-empty">
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                  </ul>
                  <ul class="rating-stars rating-stars-filled" style="width:100%;">
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                  </ul>
                </div><!-- /rating -->
                <span class="rating-stars-count">7</span>
              </div>
            </div>
            <div class="buttons clearfix" data-context="status:IN STOCK">
              <div class="button-container" id="B49913-buttons"></div>
              <div class="cartaction" id="B49913-cartaction"></div>
              <div class="add-to-cart button-atb button-full-width cart-loading button-loading" id="B49913-loading">
                <span class="text">Add To Bag</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    HTML

    merchant = MockMerchant.new('add', '//www.adidas.ca')
    merchant.extend(Merchants::AdidasCanada)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'men\'s sport essentials french terry hoodie', article_hash[:name]
    assert_equal 'Men\'s sport essentials french terry hoodie', article_hash[:description]
    assert_equal '64.95', article_hash[:price]
    assert_equal 'B49913', article_hash[:sku]
    assert_equal '//www.adidas.ca/en/mens-sport-essentials-french-terry-hoodie/B49913.html', article_hash[:link]
  end

  def test_should_extract_attrs_sporting_life
    frag = <<~HTML
      <div class="product-card col-xs-6 col-sm-4 col-md-4 small-padding columns-3">
        <div class="col-md-12 clearfix no-padding">
          <div class="product-image col-xs-12 no-padding">
            <div class="image-container">
              <div>
                <a href="https://www.sportinglife.ca/p/23771496/womens-snow-mantra-parka;jsessionid=Ee+Id+yrQAJPanGJNbTJpA__.com2" title="View Product Details for Women's Snow Mantra Parka"><img alt="Women's Snow Mantra Parka" border class="" height="" id="23771496_small_image" onerror="this.src='https://www.sportinglife.ca/static/img/imgNotFound_list.png'" src="https://www.sportinglife.ca/images/products/small/23771496_RED_5.JPG" style="" title="Women's Snow Mantra Parka" width=""></a>
              </div>
            </div>
            <div class="quickview-bar">
              <a data-target="#modal" data-toggle="modal" href="/modalTemplate.jsp?contentURL=browse/include/productQuickView.jsp?productId=23771496">
              <div>
                <span>Quick View</span> <svg class="svg_quickview svg-icon mini grey">
                <switch>
                  <use xlink:href="#quickview" xmlns:xlink="http://www.w3.org/1999/xlink"></use>
                  <foreignobject>
                    <div></div>
                  </foreignobject>
                </switch></svg>
              </div></a>
            </div>
          </div>
          <div class="swatches col-xs-12 hidden-xs">
            <a class="swatchDisplayLink" data-swatch-url="https://www.sportinglife.ca/images/products/small/23771496_BLACK_5.JPG" href="javascript:void(0);" rel="23771496"><img alt="BLACK" border class="unselected-swatch" height="" id="" src="https://www.sportinglife.ca/images/swatches/sku_specific/23771496_BLACK_7.JPG" style="" title="BLACK" width=""></a> <a class="swatchDisplayLink" data-swatch-url="https://www.sportinglife.ca/images/products/small/23771496_NAVY_5.JPG" href="javascript:void(0);" rel="23771496"><img alt="NAVY" border class="unselected-swatch" height="" id="" src="https://www.sportinglife.ca/images/swatches/sku_specific/23771496_NAVY_7.JPG" style="" title="NAVY" width=""></a> <a class="swatchDisplayLink" data-swatch-url="https://www.sportinglife.ca/images/products/small/23771496_RED_5.JPG" href="javascript:void(0);" rel="23771496"><img alt="RED" border class="unselected-swatch" height="" id="" src="https://www.sportinglife.ca/images/swatches/default/RED.JPG" style="" title="RED" width=""></a>
          </div>
          <div class="product-name no-padding col-xs-12">
            <h4 class="font-secondary"><strong>Canada Goose</strong></h4><a class="productDetailsLink-23771496" href="https://www.sportinglife.ca/p/23771496/womens-snow-mantra-parka;jsessionid=Ee+Id+yrQAJPanGJNbTJpA__.com2" title="View Product Details for&nbsp;Women's Snow Mantra Parka">
            <h5>Women's Snow Mantra Parka</h5></a>
          </div>
          <div class="rating no-padding col-xs-12 hidden-xs">
            <div class="pr_snippet_category" id="pr_category_23771496">
              <script type="text/javascript">
                    if (typeof POWERREVIEWS !== 'undefined') {
                        var pr_snippet_min_reviews=0;
                        POWERREVIEWS.display.snippet({write : function(content) {
                            if(/<link/i.test(content)) {
                                $('head').append(content);
                            } else {
                                $('#pr_category_23771496').append(content);
                            }
                        }}, { pr_page_id : "23771496" });
                    }
              </script>
            </div>
          </div>
          <div class="price no-padding col-xs-12" id="displayPrices_23771496">
            <div>
              <p><span>$1,495.00</span></p>
            </div>
          </div>
          <div class="prodregprice font-secondary"></div>
          <div class="col-md-12 pull-left hidden-sm hidden-xs">
            <div class="checkbox">
              <label><input class="compareCheck" id="productCompare-23771496" name="product_compare" title="Compare this product" type="checkbox" value="23771496"> <a href="/comparison/productComparison.jsp;jsessionid=Ee+Id+yrQAJPanGJNbTJpA__.com2" title="Compare this product">Compare</a></label>
            </div>
          </div>
        </div>
      </div>
    HTML

    merchant = MockMerchant.new('slf', '//www.sportinglife.ca')
    merchant.extend(Merchants::SportingLife)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'women\'s snow mantra parka', article_hash[:name]
    assert_equal 'Canada goose women\'s snow mantra parka', article_hash[:description]
    assert_equal '1,495.00', article_hash[:price]
    assert_equal '23771496', article_hash[:sku]
    assert_equal '//www.sportinglife.ca/p/23771496/womens-snow-mantra-parka', article_hash[:link]
  end

  def test_should_extract_attrs_sporting_life_with_discount
    frag = <<~HTML
      <div class="product-card col-xs-6 col-sm-4 col-md-4 small-padding columns-3">
        <div class="col-md-12 clearfix no-padding">
          <div class="product-image col-xs-12 no-padding">
            <div class="image-container">
              <div>
                <a href="https://www.sportinglife.ca/p/24717522/womens-double-downtown-parka" title="View Product Details for Women's Double Downtown Parka"><img alt="Women's Double Downtown Parka" border class="" height="" id="24717522_small_image" onerror="this.src='https://www.sportinglife.ca/static/img/imgNotFound_list.png'" src="https://www.sportinglife.ca/images/products/small/24717522_OLIVE_5.JPG" style="" title="Women's Double Downtown Parka" width=""></a>
              </div>
            </div>
            <div class="quickview-bar">
              <a data-target="#modal" data-toggle="modal" href="/modalTemplate.jsp?contentURL=browse/include/productQuickView.jsp?productId=24717522">
              <div>
                <span>Quick View</span> <svg class="svg_quickview svg-icon mini grey">
                <switch>
                  <use xlink:href="#quickview" xmlns:xlink="http://www.w3.org/1999/xlink"></use>
                  <foreignobject>
                    <div></div>
                  </foreignobject>
                </switch></svg>
              </div></a>
            </div>
          </div>
          <div class="swatches col-xs-12 hidden-xs">
            <a class="swatchDisplayLink" data-swatch-url="https://www.sportinglife.ca/images/products/small/24717522_OLIVE_5.JPG" href="javascript:void(0);" rel="24717522"><img alt="OLIVE" border class="unselected-swatch" height="" id="" src="https://www.sportinglife.ca/images/swatches/sku_specific/24717522_OLIVE_7.JPG" style="" title="OLIVE" width=""></a>
          </div>
          <div class="product-name no-padding col-xs-12">
            <h4 class="font-secondary"><strong>Sam</strong></h4><a class="productDetailsLink-24717522" href="https://www.sportinglife.ca/p/24717522/womens-double-downtown-parka" title="View Product Details for&nbsp;Women's Double Downtown Parka">
            <h5>Women's Double Downtown Parka</h5></a>
          </div>
          <div class="rating no-padding col-xs-12 hidden-xs">
            <div class="pr_snippet_category" id="pr_category_24717522">
              <script type="text/javascript">
                    if (typeof POWERREVIEWS !== 'undefined') {
                        var pr_snippet_min_reviews=0;
                        POWERREVIEWS.display.snippet({write : function(content) {
                            if(/<link/i.test(content)) {
                                $('head').append(content);
                            } else {
                                $('#pr_category_24717522').append(content);
                            }
                        }}, { pr_page_id : "24717522" });
                    }
              </script>
              <div id="pr-snippet-holder-1">
                <link href="//cdn.powerreviews.com/aux/11009/9576/css/express.css" id="prMerchantOverrideStylesheet" rel="stylesheet" type="text/css">
                <div class="pr-snippet" id="pr-snippet-24717522-1">
                  <div class="pr-snippet-wrapper">
                    <div class="pr-snippet-stars">
                      <div class="pr-stars pr-stars-small pr-stars-0-sm" style="background-position: 0px 0px;" title="Got it? Rate it.">
                        &nbsp;
                      </div><span class="pr-snippet-rating-decimal pr-rounded">0.0</span> <!--
            ## // TODO: this is for the forthcoming histogram
            ##<a id="pr-rating-popout" href=""><div class="pr-popout"></div></a>
            -->
                    </div>
                    <p class="pr-snippet-review-count">(No reviews)</p>
                    <div class="pr-snippet-read-write">
                      <div class="pr-snippet-write-first-review">
                        <p>Be the first to</p><a class="pr-snippet-link" data-pr-event="snippet-write-review" href="https://www.sportinglife.ca/review/addReview.jsp?pr_page_id=24717522">Write a Review</a>
                      </div>
                      <div class="pr-clear"></div>
                    </div>
                    <div class="pr-clear"></div>
                    <div class="pr-snippet-social-bar">
                      <div class="pr-clear"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="price no-padding col-xs-12" id="displayPrices_24717522">
            <div>
              <p><small>reg.</small>&nbsp;<span>$1,295.00</span></p>
              <p><small>now</small>&nbsp;<span class="red">$799.99</span></p>
            </div>
          </div>
          <div class="prodregprice font-secondary"></div>
          <div class="col-md-12 pull-left hidden-sm hidden-xs">
            <div class="checkbox">
              <label><input class="compareCheck" id="productCompare-24717522" name="product_compare" title="Compare this product" type="checkbox" value="24717522"> <a href="/comparison/productComparison.jsp" title="Compare this product">Compare</a></label>
            </div>
          </div>
        </div>
      </div>
    HTML

    merchant = MockMerchant.new('slf', '//www.sportinglife.ca')
    merchant.extend(Merchants::SportingLife)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'women\'s double downtown parka', article_hash[:name]
    assert_equal 'Sam women\'s double downtown parka', article_hash[:description]
    assert_equal '799.99', article_hash[:price]
    assert_equal '24717522', article_hash[:sku]
    assert_equal '//www.sportinglife.ca/p/24717522/womens-double-downtown-parka', article_hash[:link]
  end

  def test_should_extract_attrs_sporting_life_2
    frag = <<~HTML
      <div class="product-card col-xs-6 col-sm-4 col-md-4 small-padding columns-3">
        <div class="col-md-12 clearfix no-padding">
          <div class="product-image col-xs-12 no-padding">
            <div class="image-container">
              <div>
                <a href="https://www.sportinglife.ca/p/23416688/womens-polar-bears-international-expedition-parka" title="View Product Details for Women's Polar Bears International Expedition Parka"><img alt="Women's Polar Bears International Expedition Parka" border class="" height="" id="23416688_small_image" onerror="this.src='https://www.sportinglife.ca/static/img/imgNotFound_list.png'" src="https://www.sportinglife.ca/images/products/small/23416688_PBI_BLUE_5.JPG" style="" title="Women's Polar Bears International Expedition Parka" width=""></a>
              </div>
            </div>
            <div class="quickview-bar">
              <a data-target="#modal" data-toggle="modal" href="/modalTemplate.jsp?contentURL=browse/include/productQuickView.jsp?productId=23416688">
              <div>
                <span>Quick View</span> <svg class="svg_quickview svg-icon mini grey">
                <switch>
                  <use xlink:href="#quickview" xmlns:xlink="http://www.w3.org/1999/xlink"></use>
                  <foreignobject>
                    <div></div>
                  </foreignobject>
                </switch></svg>
              </div></a>
            </div>
          </div>
          <div class="swatches col-xs-12 hidden-xs">
            <a class="swatchDisplayLink" data-swatch-url="https://www.sportinglife.ca/images/products/small/23416688_PBI_BLUE_5.JPG" href="javascript:void(0);" rel="23416688"><img alt="PBI BLUE" border class="unselected-swatch" height="" id="" src="https://www.sportinglife.ca/images/swatches/sku_specific/23416688_PBI_BLUE_7.JPG" style="" title="PBI BLUE" width=""></a>
          </div>
          <div class="product-name no-padding col-xs-12">
            <h4 class="font-secondary"><strong>Canada Goose</strong></h4><a class="productDetailsLink-23416688" href="https://www.sportinglife.ca/p/23416688/womens-polar-bears-international-expedition-parka" title="View Product Details for&nbsp;Women's Polar Bears International Expedition Parka">
            <h5>Women's Polar Bears International Expedition Parka</h5></a>
          </div>
          <div class="rating no-padding col-xs-12 hidden-xs">
            <div class="pr_snippet_category" id="pr_category_23416688">
              <script type="text/javascript">
                    if (typeof POWERREVIEWS !== 'undefined') {
                        var pr_snippet_min_reviews=0;
                        POWERREVIEWS.display.snippet({write : function(content) {
                            if(/<link/i.test(content)) {
                                $('head').append(content);
                            } else {
                                $('#pr_category_23416688').append(content);
                            }
                        }}, { pr_page_id : "23416688" });
                    }
              </script>
            </div>
          </div>
          <div class="price no-padding col-xs-12" id="displayPrices_23416688">
            <div>
              <p><span>$1,045.00</span></p>
            </div>
          </div>
          <div class="prodregprice font-secondary"></div>
          <div class="col-md-12 pull-left hidden-sm hidden-xs">
            <div class="checkbox">
              <label><input class="compareCheck" id="productCompare-23416688" name="product_compare" title="Compare this product" type="checkbox" value="23416688"> <a href="/comparison/productComparison.jsp" title="Compare this product">Compare</a></label>
            </div>
          </div>
        </div>
      </div>
    HTML

    merchant = MockMerchant.new('slf', '//www.sportinglife.ca')
    merchant.extend(Merchants::SportingLife)

    article_hash = merchant.extract_attrs!(Nokogiri::HTML::DocumentFragment.parse(frag).at_css('div'))
    assert_equal 'women\'s polar bears international expedition parka', article_hash[:name]
    assert_equal 'Canada goose women\'s polar bears international expedition parka', article_hash[:description]
    assert_equal '1,045.00', article_hash[:price]
    assert_equal '23416688', article_hash[:sku]
    assert_equal '//www.sportinglife.ca/p/23416688/womens-polar-bears-international-expedition-parka', article_hash[:link]
  end

  def test_should_extract_attrs_sephora_canada
    frag = {
      'id'                    => 'P422856',
      'display_name'          => 'Limited-Edition Pretty & Purrrfect Eye Set',
      'variation_type'        => 'None',
      'product_type'          => 'standard',
      'product_url'           => '/product/limited-edition-pretty-purrrfect-eye-set-P422856',
      'brand_name'            => 'tarte',
      'default_sku_id'        => '1994714',
      'rating'                => 0,
      'certona_algorithm_id'  => 'g5',
      'certona_experience_id' => '852',
      'certona_audience_id'   => '187',
      'certona_strategy_id'   => '17873',
      'sku_number'            => '1994714',
      'sku_size'              => '',
      'sku_type'              => 'Standard',
      'list_price'            => 26.00,
      'primary_product_id'    => 'P422856',
      'additional_sku_desc'   => 'Limited-Edition Pretty & Purrrfect Eye Set Brilliant',
      'grid_images'           => '/productimages/sku/s1994714-main-grid.jpg',
      'hero_images'           => '/productimages/sku/s1994714-main-hero.jpg',
      'ingredients'           => '-Natural Waxes => Ensures a smooth application.-Vitamin A => Hydrates and helps protect against free radical damage.-Vitamin E => Acts as an emollient and antioxidant.-Castor Oil => Treats and moisturizes skin around the lash line.-Triple-Black Painted Mineral Pigments => Delivers rich, ultra-back pigment while nourishing and softening skin around the lash line. Deluxe Sex Kitten EyelinerCyclopentasiloxane, Trimethylsiloxysilicate, Polyethylene, Isododecane, Ceresin, Diisostearyl Malate, Triethoxycaprylylsilane, Silica Silylate, Phenoxyethanol, Ethylhexylglycerin, Kaolin. (+/-) => Iron Oxides (CI 77499). Deluxe Sex Kitten Liquid EyelinerWater, Acrylates/Ethylhexyl Acrylate/HEMA Copolymer, Propylene Glycol, Ammonium Acrylates Copolymer, Acrylates/Diethylaminoethyl Methacrylate/Ethylhexyl Acrylate Copolymer, Laureth-21, PEG-40 Hydrogenated Castor Oil, Caprylyl Glycol, Butylene Glycol, Isodeceth-6, Sodium Laureth Sulfate, Ethylhexylglycerin, Algae Extract, Glycerin, Phenoxyethanol, Potassium Sorbate, Sodium Dehydroacetate, Black 2 (CI 77266). Travel Size Tarteist&trade; Lash Paint MascaraWater, Paraffin, Glyceryl Stearate, Synthetic Beeswax, Acacia Senegal Gum, Stearic Acid, Butylene Glycol, Oryza Sativa (Rice) Bran Wax/Oryza Sativa (Rice) Bran Cera, Palmitic Acid, Polybutene, Ozokerite, VP/Eicosene Copolymer, Hydrogenated Vegetable Oil, Cera Carnauba/Copernicia Cerifera (Carnauba) Wax/Cire De Carnauba, Phenoxyethanol, Stearyl Stearate, Aminomethyl Propanol, Hydroxyethylcellulose, Tropolone, Sodium Nitrate, Iron Oxides (CI 77499).',
      'is_sephora_exclusive'  => false,
      'is_online_only'        => false,
      'is_limited_edition'    => true,
      'is_new'                => true,
      'variation_value'       => '' }

    merchant = MockMerchant.new('sph', '//www.sephora.com')
    merchant.extend(Merchants::SephoraCanada)

    article_hash = merchant.extract_attrs!(frag)
    assert_equal 'limited-edition pretty & purrrfect eye set', article_hash[:name]
    assert_equal 'Tarte limited-edition pretty & purrrfect eye set brilliant', article_hash[:description]
    assert_equal 26.00, article_hash[:price]
    assert_equal '1994714', article_hash[:sku]
    assert_equal '//www.sephora.com/product/limited-edition-pretty-purrrfect-eye-set-P422856', article_hash[:link]
  end
end