module Merchants
  module YvesSaintLaurentBeautyCanada
    def query_strings
      { format: :ajax,
        sz:     1000 } # page size, looks like it works with large number
    end

    def extract_attrs!(node)
      article_node        = node.at_css('div.action_product_block') # more specific article div block
      product_sku         = node['data-itemid']
      product_name        = article_node.at_css('a.product_name')['title'].squish.downcase
      product_link        = URI(article_node.at_css('a.product_name')['href'])
      product_description = article_node.at_css('div.description').content.squish
      product_price       = article_node.at_css('p.product_price')['data-pricevalue']

      { sku:         product_sku,
        name:        product_name,
        description: product_description,
        link:        "//#{product_link.host}#{product_link.path}",
        price:       product_price }
    end
  end
end