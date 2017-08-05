module Merchants
  module Ssense
    def self.extended(merchant)
      merchant.indexer = SsenseIndexer
      merchant.extend Parser
    end

    class SsenseIndexer < Indexer
      def compute_index_page
        last_page_node = pager_node&.at_css('li.last-page a')
        return [] unless last_page_node

        last_page_path = last_page_node['href']
        last_page_uri  = URI('%<scheme>s:%<domain>s%<path>s' % {
          scheme: @index_page.scheme,
          domain: @merchant_metadatum.domain,
          path:   last_page_path
        })

        query       = Hash[Rack::Utils.parse_nested_query(last_page_uri.query)]
        page_uri    = last_page_uri.dup.tap { |uri| uri.query = nil }
        total_pages = query['page'].to_i
        (1..total_pages).map do |page_number|
          query['page'] = page_number
          IndexPage.new(relative_path: page_uri.path + '?' + Rack::Utils.build_query(query),
                        merchant:      @merchant,
                        index_page:    @index_page)
        end
      end
    end

    module Parser
      def attrs_from_node(node)
        product_sku   = node['data-product-sku']
        product_name  = node['data-product-name']
        product_price = node['data-product-price']
        product_brand = node['data-product-brand']

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