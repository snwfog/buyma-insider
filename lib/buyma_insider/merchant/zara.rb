##
# Zara
#
class Zara < Merchant::Base
  self.base_url    = 'http://www.zara.com/ca/en'
  self.index_pages = [
    'women/new-in-c840002.html'
  ]
  self.item_css    = 'ul.product-list li.product'
end