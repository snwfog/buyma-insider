##
# Shoeme article
#
class ShoemeArticle < Article
  self.merchant_code = 'sho'

  def self.attrs_from_node(node)
    /'(?<name>[-\w]+)'/ =~ node.at_css('div.product-title a')['onmousedown']
    href = node.at_css('div.product-title a')['href']

    {
      id:          "#{merchant_code}:#{href[/[a-z\d]{1,10}$/]}",
      name:        name,
      price:       node.at_css('div.product-price p.product-price').content[/[\d]{1,10}\.[\d]{2}/],
      description: name,
      link:        href,
      '_type':     self.to_s
    }
  end
end
