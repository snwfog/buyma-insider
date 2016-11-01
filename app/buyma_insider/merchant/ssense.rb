module Merchant
  class Ssense < Base
    self.code        = 'sse'
    self.base_url    = '//www.ssense.com'
    self.index_pages = [
      'en-ca/men',
      'en-ca/women'
    ]
    
    # Move this into article
    self.item_css    = 'div.browsing-product-list div.browsing-product-item'
    
    def self.attrs_from_node(node)
      {
        id:          "#{code}:#{node['data-product-sku']}",
        name:        node['data-product-name'],
        price:       node['data-product-price'],
        description: "#{node['data-product-brand']} - #{node['data-product-name']}",
        link:        "#{base_url}#{node.at_css('a')['href']}",
        '_type':     self.to_s
      }
    end
  end
end
