module Merchants
  module Ssense
    def extract_index_pages!(root_index_page)
      pager_node     = super
      last_page_node = pager_node.try(:at_css, 'li.last-page a')
      return [] unless last_page_node

      last_page_path = last_page_node['href']
      last_page_uri  = URI('%<scheme>s:%<domain>s%<path>s' % {
        scheme: index_page.scheme,
        domain: merchant_metadatum.domain,
        path:   last_page_path
      })

      query       = Hash[Rack::Utils.parse_nested_query(last_page_uri.query)]
      page_uri    = last_page_uri.dup.tap { |uri| uri.query = nil }
      total_pages = query['page'].to_i
      (1..total_pages).map do |page_number|
        query['page'] = page_number
        IndexPage.new(relative_path: page_uri.path + '?' + Rack::Utils.build_query(query),
                      merchant:      merchant,
                      index_page:    index_page)
      end
    end

    def extract_attrs!(node)
      product_sku   = node.at_css('meta[itemprop=sku]')['content'].strip
      product_name  = node.at_css('figcaption.browsing-product-description > p[itemprop=name]').content.strip.downcase
      product_brand = node.at_css('figcaption.browsing-product-description > p[itemprop=brand]').content.strip
      product_price = node.at_css('meta[itemprop=price]')['content']
      product_link  = node.at_css('meta[itemprop=url]')['content']

      { sku:         product_sku,
        name:        product_name,
        description: "#{product_brand.capitalize} - #{product_name.capitalize}",
        link:        product_link.sub(/https?:/, ''),
        price:       product_price }
    end
  end
end