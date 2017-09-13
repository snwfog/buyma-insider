module Merchants
  module CanadaGoose
    def extract_attrs!(node)
      product_sku           = node[:id]
      product_name          = node.at_css('div.product-name a')['title']
      product_price         = node.at_css('div.product-pricing span[itemprop=price]')['content']
      product_relative_link = node.at_css('div.product-name a')['href']

      { sku:         product_sku,
        name:        product_name,
        description: product_name,
        link:        domain + product_relative_link,
        price:       product_price }
    end
  end
end