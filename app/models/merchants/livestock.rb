module Merchants
  module Livestock
    def self.extended(merchant)
      merchant.indexer = LivestockIndexer
      merchant.extend Parser
    end

    class LivestockIndexer < Indexer
      def compute_index_page
        page_nodes     = pager_node.css('span.page > a')
        last_page_node = page_nodes.last
        last_page_path = last_page_node['href'] # this is relative path
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

    end
  end
end