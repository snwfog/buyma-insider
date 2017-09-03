# Notes:
# 1. It looks like X-Forwarded-For headers works
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
        product_id          = node['data-productid']
        product_description = node.at_css('div.product-info a.name._item')
        price               = node.at_css('div.product-info div.price._product-price span')

        { sku:         product_id.strip,
          name:        product_description.content.strip.downcase,
          description: product_description.content.strip.capitalize,
          link:        item['href'],
          price:       price['data-price'][/[$]?[\d]{1,10}\.[\d]{2}/] }
      end
    end
  end
end