##
# Zara
#
class Zara < Merchant::Base
  self.base_url    = '//www.zara.com/ca/en'
  self.index_pages = [
    'women/new-in-c840002.html',
    # 'woman/trending-picks-c858027.html',
    # 'woman/outerwear/view-all-c733882.html'
  ]
  self.item_css    = 'ul.product-list li.product'
end