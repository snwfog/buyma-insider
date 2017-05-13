module Merchants
  module Octobersveryown
    def self.extended(merchant)
      merchant.indexer = OctobersveryownIndexer
      merchant.extend Parser
    end
    
    class OctobersveryownIndexer < Indexer;
    end
    
    module Parser
      def attrs_from_node(node)
        name_node, price_node = node.css('p')
        link_node             = node.css('a').first
        price                 = price_node.content[1..-1].to_f
        name                  = AsciiFolding.fold(name_node.at_css('a').content)
        link                  = link_node['href']
        sku                   = Digest::MD5.hexdigest(name.titleize)
        
        { id:          "#{code}:#{sku}",
          # There is a sku, but its only shown
          # by fetching the article
          sku:         sku,
          name:        name.titleize,
          price:       price,
          # We can actually get a better description
          # by fetching the page and reading the meta tag
          description: name.capitalize,
          link:        '%s%s' % [domain, link] }
      end
    end
  end
end