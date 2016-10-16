##
# Zara article
#
class ZaraArticle < Article
  self.merchant_code = 'zar'

  def self.attrs_from_node(n)
    item_a = n.at_css('a.item._item')
    desc_a = n.at_css('div.product-info a.name._item')
    price  = n.at_css('div.product-info div.price._product-price span')

    {
      id:          n['data-productid'],
      name:        desc_a.content,
      price:       price['data-price'][/[$]?[\d]{1,10}\.[\d]{2}/],
      description: desc_a.content,
      link:        item_a['href'],
      '_type':     self.to_s
    }
  end
end