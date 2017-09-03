module Merchants
  module Octobersveryown
    def self.extended(merchant)
      merchant.indexer = OctobersveryownIndexer
      merchant.extend Parser
    end

    class OctobersveryownIndexer < Indexer
    end

    module Parser
      def attrs_from_node(node)
        name_node, price_node = node.css('p')
        product_link_node     = node.css('a').first
        product_price         = price_node.content.strip[/(?<=\$)?(([\d]{1,3}),?)+\.[\d]{2}/]
        product_name          = AsciiFolding.fold(name_node.at_css('a').content.squish).downcase
        product_relative_path = product_link_node['href']

        # WARN: Changing this will mess up product sku
        product_sku = Digest::MD5.hexdigest(product_name)

        # There is a sku, but its only shown
        # by fetching the article
        { sku:  product_sku,
          name: product_name,
          # We can actually get a better description
          # by fetching the page and reading the meta tag
          description: product_name.capitalize,
          link:        "#{domain}#{product_relative_path}",
          price:       product_price }
      end
    end
  end
end