module Merchants
  module AdidasCanada
    def extract_index_pages!(root_index_page)
      # Top pager is picked
      pager_node = super

      pager_node.css('select.paging-select option').map do |page_node|
        page_uri      = URI(page_node['data-href'])
        relative_path = "#{page_uri.path}?#{page_uri.query}"
        root_index_page.index_pages.build(relative_path: relative_path,
                                          merchant:      self)
      end
    end

    def extract_attrs!(node)
      data_context_attrs = Hash[*node['data-context'].split(/[:;]/, -1)]
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