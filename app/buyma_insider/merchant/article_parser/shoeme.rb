module Merchant::ArticleParser::Shoeme
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