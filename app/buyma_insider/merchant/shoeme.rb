##
# Store merchant information
#
class Shoeme < Merchant::Base
  # IMPT: This is the crawl URL, not the merchant url
  self.base_url    = '//shoeme.ecomm-nav.com'
  self.index_pages = [
    'collections/womens-shoes',
  ]

  # Move this into article
  self.item_css    = 'ul.product-list li.product-li'
end
