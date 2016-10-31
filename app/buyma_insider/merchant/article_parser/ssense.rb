module Merchant::ArticleParser::Ssense
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