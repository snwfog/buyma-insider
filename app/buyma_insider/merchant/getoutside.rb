##
# Store merchant information
#
class Getoutside < Merchant::Base
  self.base_url    = '//www.getoutsideshoes.com'
  self.index_pages = [
    'new-arrivals.html',
    'mens.html',
    'womens.html',
    'kid-s.html',
    'accessories.html',
    'sale.html'
  ]

  # Move this into article
  self.item_css    = 'ul.products-grid li.item'
end
