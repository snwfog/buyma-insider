module Merchants
  module Livestock
    def extract_index_pages!(root_index_page)
      # Top pager is picked
      pager_node              = super
      last_page_node          = pager_node.css('span.page a').last
      last_page_relative_path = URI(last_page_node['href'])

      query_strings    = Rack::Utils
                           .parse_nested_query(last_page_relative_path.query)
                           .symbolize_keys!
      last_page_number = query_strings[:page]
      puts query_strings.class
      ('1'..last_page_number).map do |page_number|
        query_strings[:page] = page_number
        IndexPage.new(index_page:    index_page,
                      merchant:      merchant,
                      relative_path: "#{last_page_relative_path.path}?#{Rack::Utils.build_query(query_strings)}")
      end
    end

    def extract_attrs!(node)
      product_node          = node.at_css('a')
      product_relative_path = URI(product_node['href'])

      product_info_node = node.at_css('div.info')
      product_title     = product_info_node.at_css('span.title').content.strip.downcase
      product_title     = AsciiFolding.fold(product_title)

      product_price_str = product_info_node.at_css('span.price span.money').content
      product_price     = product_price_str[/(?<=\$)?(([\d]{1,3}),?)+\.[\d]{2}/]
      product_sku       = Digest::MD5.hexdigest(product_title)

      { sku:         product_sku,
        name:        product_title,
        description: product_title.capitalize,
        link:        "#{domain}#{product_relative_path.path}",
        price:       product_price }
    end
  end
end