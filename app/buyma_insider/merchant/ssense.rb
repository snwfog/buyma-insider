module Merchant
  class Ssense < Base
    extend ArticleParser
    # extend Indexer

    self.code        = 'sse'
    self.base_url    = '//www.ssense.com'
    self.index_pages = [
        'en-ca/men',
        'en-ca/women']

    # Move this into article
    self.item_css    = 'div.browsing-product-list div.browsing-product-item'
  end

  module ArticleParser
    def attrs_from_node(node)
      {
          id:          "#{merchant_code}:#{node['data-product-sku']}",
          name:        node['data-product-name'],
          price:       node['data-product-price'],
          description: "#{node['data-product-brand']} - #{node['data-product-name']}",
          link:        "#{base_url}#{node.at_css('a')['href']}",
          '_type':     self.to_s
      }
    end
  end

  module Indexer
    self.pager_css = 'div.browsing-pagination ul.nav'

    def compute_page
      raise unless block_given?

      page_nodes = index_document.at_css(self.pager_css)
      first_node = page_nodes.css('li:not(.hidden)').first
      last_node  = page_nodes.at_css('li:not(.hidden).last-page')

      first_page = first_node.content.to_i
      last_page  = last_node.at_css('a').content.to_i

      (first_page..last_page).each { |i| yield "#{index_url}/pages/#{i}" }
    end
  end
end
