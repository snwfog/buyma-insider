module Merchant
  class Shoeme < Base
    # extend Indexer
    extend Merchant::ArticleParser

    self.code        = 'sho'
    # IMPT: This is the crawl URL, not the merchant url
    self.base_url    = '//shoeme.ecomm-nav.com'
    self.index_pages = [
        'collections/womens-shoes',
        'collections/mens-shoes',
        'collections/kids',
        'collections/all-bags',
        'collections/sale'
    ]

    # Move this into article
    self.item_css    = 'ul.product-list li.product-li'
  end

  module ArticleParser
    def attrs_from_node(node)
      product_title_node = node.at_css('div.product-title')

      brand      = product_title_node.at_css('h5').content
      short_desc = product_title_node.at_css('h6').child.content.strip
      desc       = "#{brand} - #{short_desc}"

      {
          id:          "#{merchant_code}:#{Digest::MD5.hexdigest(desc)}",
          name:        desc,
          price:       node.at_css('div.product-price p.product-price').content[/[\d]{1,10}\.[\d]{2}/],
          description: desc,
          link:        product_title_node.at_css('a')['href'],
          '_type':     self.to_s
      }
    end
  end

  module Indexer
    self.pager_css = 'div.nxt-pagination'

    def initialize(path, merchant_klazz)
      super("nav?initial_url=http://www.shoeme.ca/#{path}", merchant_klazz)
    end

    def compute_page
      raise unless block_given?

      page_nodes = index_document.at_css(self.pager_css)
      first_node = page_nodes.at_css('ul li:first-child')
      last_node  = page_nodes.at_css('ul li:last-child')

      first_page = first_node.at_css('span.nxt-current').content.to_i
      /page-(?<last_page>[\d]{1,10})/ =~ last_node.at_css('a.nxt-pages-next')['href']
      (first_page..last_page.to_i).each { |i| yield "#{index_url}&page=#{i}" }
    end
  end
end
