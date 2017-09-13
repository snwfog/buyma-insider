module Merchants
  module Sephora
    def self.extended(merchant)
      merchant.indexer = SephoraIndexer
    end

    def extract_index_pages!(root_index_page)
      super

    end

    def extract_nodes!(index_page)
      js_content = index_page.cache.web_document

      # Sephora.certona({ ... });
      js_string = <<~JAVASCRIPT
        var Sephora = { certona: function(articleProperties) { 
                                   return articleProperties; 
                                 } };
        return #{js_content}
      JAVASCRIPT

      articles_hash = ExecJS.exec(js_string)
    end

    def extract_attrs!(hash_node)

    end
  end
end