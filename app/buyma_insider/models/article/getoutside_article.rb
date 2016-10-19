##
# Getoutside article
#
class GetoutsideArticle < Article
  self.merchant_code = 'get'

  def self.attrs_from_node(node)
    product_image_link = node.at_css('a.product-image')

    {
      id:          "#{merchant_code}:#{node.at_css('div.price-box span.regular-price')['id'][/[\d]{1,10}/]}",
      name:        product_image_link['title'],
      price:       node.at_css('div.price-box span.price').content[/[$]?[\d]{1,10}\.[\d]{2}/],
      description: node.at_css('h2.product-name a').content,
      link:        product_image_link['href'],
      '_type':     self.to_s
    }
  end
end
