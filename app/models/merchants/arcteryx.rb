module Merchants
  module Arcteryx
    def self.extended(m)
      m.indexer = ArcteryxIndexer
      m.extend Parser
    end

    class ArcteryxIndexer < Indexer
    end

    module Parser
      def attrs_from_node(node)
        product_sku               = node['data-model']
        product_name              = node.at_css('span.searchResultName').child.to_s
        product_description       = node.at_css('span.description').try(:content)
        product_description_short = node.at_css('span.subMarketName').try(:content)
        product_price             = node.at_css('span.searchResultPrice').content[/(?<=\$)(([\d]{1,3}),?)+\.[\d]{2}/]
        product_relative_link     = node.at_css('a')['href']

        { name:        product_name.strip,
          sku:         product_sku,
          description: product_description.try(:strip) || product_description_short.try(:strip) || product_name.strip,
          price:       product_price,
          link:        domain + '/' + product_relative_link }
      end
    end
  end
end