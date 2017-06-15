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
        item                = node.at_css('a.item._item')
        product_id          = node.fetch('data-productid')
        product_description = node.at_css('div.product-info a.name._item')
        price               = node.at_css('div.product-info div.price._product-price span')
        
        { id:          "#{code}:#{product_id}",
          sku:         product_id,
          name:        product_description.content.titleize,
          price:       price['data-price'][/[$]?[\d]{1,10}\.[\d]{2}/],
          description: product_description.content.capitalize,
          link:        item['href'] }
      end
    end
  end
end