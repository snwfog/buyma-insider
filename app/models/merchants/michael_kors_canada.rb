module Merchants
  module MichaelKorsCanada
    def headers
      standard_headers = super
      # mk does not respond when this header is added
      standard_headers.delete(:x_forwarded_for)

      standard_headers
    end

    def extract_index_pages!(root_index_page)
      api_endpoint = '/server/data/guidedSearch'
      if root_index_page.relative_path == '/'
        root_index_page.cache.nokogiri_document.css('a.menu-link').inject([]) do |valid_index_page, link_node|
          category = link_node['href'].split('/').pop
          if category.start_with?('N-')
            valid_index_page.push(
              index_pages.build(relative_path: "#{api_endpoint}?stateIdentifier=_/#{category}"))
          end

          valid_index_page
        end
      else
        articles_per_page  = 42
        data_hash          = JSON.parse(root_index_page.cache.web_document)
        total_products     = data_hash.dig('result', 'totalProducts').to_i
        root_relative_path = root_index_page.relative_path
        (0..total_products).step(articles_per_page).map do |start_page|
          root_index_page.index_pages.build(relative_path: "#{root_relative_path}&No=#{start_page}", merchant: self)
        end
      end
    end

    def extract_nodes!(json_document)
      data_hash     = JSON.parse(json_document)
      product_lists = data_hash.dig('result', 'productList')
      product_lists.flat_map do |article_hash|
        skus = article_hash.delete('SKUs')
        skus.flat_map do |sku|
          article_hash.dup.merge!(sku)
        end
      end
    end

    def extract_attrs!(hash_node)
      product_relative_path = hash_node['seoURL']
      product_price         = hash_node['prices']['lowSalePrice'] || hash_node['prices']['lowListPrice']
      product_brand         = hash_node['brand']
      product_name          = hash_node['name'].squish.downcase
      description           = hash_node['description']
      product_description   = [product_brand, description].compact.join(' - ')
      product_sku           = hash_node['identifier']

      { sku:         product_sku,
        name:        product_name,
        description: product_description,
        link:        domain + product_relative_path,
        price:       product_price }
    end
  end
end