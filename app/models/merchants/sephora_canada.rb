module Merchants
  module SephoraCanada
    def extract_index_pages!(root_index_page)
      brand_anchor_nodes = root_index_page.cache.nokogiri_document.css('div.Grid li a')
      brand_anchor_nodes.map do |anchor_link|
        brand_uri = URI(anchor_link['href'])
        root_index_page.index_pages
          .build(relative_path: "#{brand_uri.path}?products=all&pageSize=-1", merchant: self)
      end
    end

    def extract_nodes!(web_document)
      html_document = Nokogiri::HTML(web_document)
      json_script   = html_document.at_css('#searchResult')

      return [] if json_script.blank?

      articles_hash = JSON.parse!(json_script.content)
      articles_hash.dig('products').flat_map do |article_hash|
        derived_sku = article_hash.delete('derived_sku')
        article_hash.merge!(derived_sku)
      end
    end

    def extract_attrs!(hash_node)
      product_link        = URI("#{domain}#{hash_node['product_url']}")
      product_name        = hash_node['display_name'].squish.downcase
      product_brand       = hash_node['brand_name']
      product_description =
        hash_node['image_alt_text'] || "#{product_brand} #{product_name}"

      product_price = hash_node['sale_price'] ||
        hash_node['list_price_min'] ||
        hash_node['list_price']

      { sku:         hash_node['sku_number'],
        name:        product_name,
        description: product_description.capitalize,
        link:        '//' + product_link.host + product_link.path,
        price:       product_price }
    end

    def cookies
      { site_locale:   'ca',
        site_language: 'en' }
    end
  end
end