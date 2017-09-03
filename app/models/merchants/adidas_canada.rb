module Merchants
  module AdidasCanada
    def self.extended(m)
      m.indexer = AdidasCanadaIndexer
      m.extend Parser
    end

    class AdidasCanadaIndexer < Indexer
      def compute_index_page
        # Top pager is picked
        pager_node.css('select.paging-select option').map do |page_node|
          page_uri      = URI(page_node['data-href'])
          relative_path = "#{page_uri.path}?#{page_uri.query}"
          merchant.index_pages.build(index_page:    index_page,
                                     relative_path: relative_path)
        end
      end
    end

    module Parser
      def attrs_from_node(node)
        data_context_attrs = Hash[*node['data-context'].split(/[:;]/)]
        product_sku        = data_context_attrs['sku']

        inner_content = node.at_css('div.product-info-inner-content')
        product_name  = inner_content.at_css('a.product-link')['data-productname'].strip.downcase
        product_desc  = product_name.capitalize
        product_link  = URI(inner_content.at_css('a.product-link')['href'])

        price_node       = node.at_css('div.product-info-price-rating')
        data_price_attrs = Hash[*price_node.at_css('div.price')['data-context'].split(/[:;]/)]
        product_price    = data_price_attrs['price']

        { sku:         product_sku,
          name:        product_name,
          description: product_desc,
          link:        '//' + product_link.host + product_link.path,
          price:       product_price }
      end
    end
  end
end