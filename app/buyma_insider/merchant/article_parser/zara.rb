module Merchant
  module ArticleParser
    module Zara
      def attrs_from_node(node)
        item_a = node.at_css('a.item._item')
        desc_a = node.at_css('div.product-info a.name._item')
        price  = node.at_css('div.product-info div.price._product-price span')
    
        {
          id:          "#{code}:#{node['data-productid']}",
          name:        desc_a.content,
          price:       price['data-price'][/[$]?[\d]{1,10}\.[\d]{2}/],
          description: desc_a.content,
          link:        item_a['href'],
          '_type':     self.to_s
        }
      end
    end
  end
end