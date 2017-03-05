module Merchants
  module Zara
    def self.extended(merchant)
      merchant.indexer = ZaraIndexer
      merchant.extend Parser
    end
    
    class ZaraIndexer < Indexer
    end
    
    module Parser
      def attrs_from_node(node)
        item  = node.at_css('a.item._item')
        desc  = node.at_css('div.product-info a.name._item')
        price = node.at_css('div.product-info div.price._product-price span')
        
        {
          id:          "#{code}:#{node['data-productid']}",
          sku:         node['data-productid'],
          name:        desc.content,
          price:       price['data-price'][/[$]?[\d]{1,10}\.[\d]{2}/],
          description: desc.content,
          link:        item['href'],
        }
      end
    end
  end
end