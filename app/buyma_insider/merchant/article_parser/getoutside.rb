module Merchant::ArticleParser::Getoutside
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