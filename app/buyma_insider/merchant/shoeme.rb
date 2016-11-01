module Merchant
  class Shoeme < Base
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

    def self.attrs_from_node(node)
      product_title_node = node.at_css('div.product-title')

      brand      = product_title_node.at_css('h5').content
      short_desc = product_title_node.at_css('h6').child.content.strip
      desc       = "#{brand} - #{short_desc}"

      encoded_link = product_title_node.at_css('a')['href']
      decoded_link = URI.decode(encoded_link)
      url_parts    = decoded_link.scan(URI.regexp).first.compact
      url_parts.shift
      link = "//#{url_parts.join}"

      {
        id:          "#{code}:#{Digest::MD5.hexdigest(desc)}",
        name:        desc,
        price:       node.at_css('div.product-price p.product-price').content[/[\d]{1,10}\.[\d]{2}/],
        description: desc,
        link:        link,
        '_type':     self.to_s
      }
    end
  end
end
