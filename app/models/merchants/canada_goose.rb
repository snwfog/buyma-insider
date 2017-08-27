module Merchants
  module CanadaGoose
    def self.extended(merchant)
      merchant.indexer = CanadaGooseIndexer
      merchant.extend Parser
    end

    class CanadaGooseIndexer < Indexer
    end

    module Parser
      def attrs_from_node(node)
        product_sku           = node[:id]
        product_name          = node.at_css('div.product-name a')['title']
        product_price         = node.at_css('div.product-pricing span[itemprop=price]')['content']
        product_relative_link = node.at_css('div.product-name a')['href']

        { sku:         product_sku,
          name:        product_name,
          description: product_name,
          link:        domain + product_relative_link,
          price:       product_price }
      end
    end
  end
end