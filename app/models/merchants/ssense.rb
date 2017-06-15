module Merchants
  module Ssense
    def self.extended(merchant)
      merchant.indexer = SsenseIndexer
      merchant.extend Parser
    end
    
    class SsenseIndexer < Indexer
      def compute_page
        raise 'Indexer#compute_page should have block' unless block_given?
        page_nodes = index_document.at_css(pager_css)
        first_node = page_nodes.css('li:not(.hidden)').first
        last_node  = page_nodes.at_css('li:not(.hidden).last-page')
        
        first_page = first_node.content.to_i
        last_page  = last_node.at_css('a').content.to_i
        
        (first_page..last_page).each { |i| yield "#{index_url}/pages/#{i}" }
      end
    end
    
    module Parser
      def attrs_from_node(node)
        product_sku   = node.fetch('data-product-sku')
        product_name  = node.fetch('data-product-name')
        product_price = node.fetch('data-product-price')
        product_brand = node.fetch('data-product-brand')
        
        { id:          "#{code}:#{product_sku}",
          sku:         product_sku,
          name:        product_name,
          price:       product_price,
          description: "#{product_brand} - #{product_name}",
          link:        "#{domain}#{node.at_css('a')['href']}", }
      end
    end
  end
end