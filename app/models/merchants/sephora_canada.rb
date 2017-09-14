module Merchants
  module SephoraCanada
    def extract_index_pages!(root_index_page)
      super

    end

    def extract_nodes!(web_document)
      js_content = web_document

      # Sephora.certona({ ... });
      js_string = <<~JAVASCRIPT
        var Sephora = { certona: function(articleProperties) { 
                                   return articleProperties; 
                                 } };
        return #{js_content}
      JAVASCRIPT

      articles_hash = ExecJS.exec(js_string)
      schemes       = articles_hash.dig('resonance', 'schemes')
      schemes.flat_map do |scheme|
        scheme_items = scheme.dig('items')
        scheme_items.flat_map do |item_default_attrs|
          skus = item_default_attrs.delete('skus')
          skus.map { |article_attrs| item_default_attrs.dup.merge!(article_attrs) }
        end
      end
    end

    def extract_attrs!(hash_node)
      product_link        = URI("#{domain}#{hash_node['product_url']}")
      product_description =
        hash_node['additional_sku_desc'] || hash_node['display_name']

      { sku:         hash_node['default_sku_id'],
        name:        hash_node['display_name'].squish.downcase,
        description: "#{hash_node['brand_name']} #{product_description}".capitalize,
        link:        '//' + product_link.host + product_link.path,
        price:       hash_node['list_price'] }
    end
  end
end