##
# Store merchant information
#
class Shoeme < Merchant::Base
  self.base_url    = '//www.shoeme.ca'
  self.index_pages = [
    'collections/womens-shoes',
  ]

  # Move this into article
  self.item_css    = 'div.browsing-product-list div.browsing-product-item'
end
