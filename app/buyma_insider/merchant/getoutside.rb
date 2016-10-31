module Merchant
  class Getoutside < Base
    # extend Indexer
    extend Merchant::ArticleParser

    self.code        = 'get'
    self.base_url    = '//www.getoutsideshoes.com'
    self.index_pages = [
        'new-arrivals.html',
        'mens.html',
        'womens.html',
        'kid-s.html',
        'accessories.html',
        'sale.html'
    ]

    # Move this into article
    self.item_css    = 'ul.products-grid li.item'
  end

  module ArticleParser
    def attrs_from_node(node)
      product_image_link = node.at_css('a.product-image')

      # This is last price, which is either regular price or special price
      # we display always the last price
      price_node         = node
                               .at_css('div.price-box')
                               .at_css('p.special-price span.price', 'span.regular-price')
      article_id         = price_node['id'][/[\d]{1,10}/]
      price              = (price_node.at_css('span.price') || price_node).content[/[$]?[\d]{1,10}\.[\d]{2}/]

      {
          id:          "#{merchant_code}:#{article_id}",
          name:        product_image_link['title'],
          price:       price,
          description: node.at_css('h2.product-name a').content,
          link:        product_image_link['href'],
          '_type':     self.to_s
      }
    end
  end

  module Indexer
    self.pager_css = 'div.pager'

    def compute_page
      raise unless block_given?
      page_nodes = index_document.at_css(self.pager_css)

      first_node = page_nodes.at_css('ol li:first-child')
      last_node  = page_nodes.css('ol li:not(.next)').last

      first_page = first_node.content.to_i
      last_page  = last_node.at_css('a').content.to_i

      (first_page..last_page).each { |i| yield "#{index_url}?p=#{i}" }
    end
  end
end
