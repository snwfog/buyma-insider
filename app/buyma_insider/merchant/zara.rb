##
# Zara
#
class Zara < Merchant::Base
  self.base_url    = '//www.zara.com/ca/en'
  self.index_pages = [
    # Woman
    'women/new-in-c840002.html',
    'woman/trending-picks-c858027.html',
    'woman/outerwear/view-all-c733882.html',
    'woman/bombers-c835053.html',
    'woman/blazers-c756615.html',
    'woman/jumpsuits-c663016.html',
    'woman/tops/view-all-c733890.html',
    'woman/trousers/view-all-c733898.html',
    'woman/shorts-c733903.html',
    'woman/jeans/view-all-c733918.html',
    'woman/skirts/view-all-c733908.html',
    'woman/knitwear/view-all-c733910.html',
    'woman/t-shirts/view-all-c733912.html',
    'woman/sweatshirts-c733914.html',
    'woman/basics/t-shirts-c846572.html',
    'woman/shoes/view-all-c734142.html',
    'woman/bags/view-all-c734144.html',
    'woman/accessories/view-all-c733915.html',
    'woman/special-prices-c783580.html',
    'woman/premium/view-all-c765596.html',
    'woman/swinging-tweed-c662001.html',

    # TRF
    'trf/new-in-c840006.html',
    'trf/coats-c502501.html',
    'trf/jackets-c665507.html',
    'trf/dresses-c269210.html',
    'trf/jumpsuits-c663017.html',
    'trf/tops-c269211.html',
    'trf/trousers-c269212.html',
    'trf/shorts-c734192.html',
    'trf/jeans/view-all-c846564.html',
    'trf/skirts-c269213.html',
    'trf/t-shirts-c269214.html',
    'trf/shoes-c269216.html',
    'trf/bags-c269223.html',
    'trf/basics/t-shirts-c841502.html',
    'trf/ungendered-c758512.html',

    'man/new-in-c744526.html',
    'man/trending-picks-c858034.html',
    'man/outerwear/view-all-c764502.html',
    'man/jackets/view-all-c758501.html',
    'man/bombers-c760013.html',
    'man/blazers-c269232.html',
    'man/trousers/view-all-c733862.html',
    'man/jeans/view-all-c733864.html',
    'man/shorts-c637013.html',
    'man/shirts/view-all-c733865.html',
    'man/t-shirts/view-all-c733866.html',
    'man/polo-shirts-c493002.html',
    'man/sweatshirts-c309502.html',
    'man/sweaters-and-cardigans/view-all-c733867.html',
    'man/basics/view-all-c853512.html',
    'man/shoes/view-all-%7C-from-size-6-c842002.html',
    'man/bags/view-all-c734090.html',
    'man/accessories/view-all-c733868.html',
    'man/soft-wear-c637037.html',
    'man/special-prices/view-all-c787511.html',
    'man/seasonals-man/seasonals-man-collection-c865501.html',
  ]

  self.item_css    = 'ul.product-list li.product'
end