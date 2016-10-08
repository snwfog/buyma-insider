##
# Store merchant information
##
class Ssense < Merchant::Base
  self.base_url    = 'https://www.ssense.com'
  self.index_pages = [
    'en-ca/men',
    'en-ca/women']
  self.item_css    = 'div.browsing-product-list div.browsing-product-item'
end
