module Merchants
  module Octobersveryown
    def extract_attrs!(html_node)
      name_node, price_node = html_node.css('p')
      product_link_node     = html_node.css('a').first
      product_price         = price_node.content.strip[/(?<=\$)?(([\d]{1,3}),?)+\.[\d]{2}/]
      product_name          = AsciiFolding.fold(name_node.at_css('a').content.squish).downcase
      product_relative_path = product_link_node['href']

      # WARN: Changing this will mess up product sku
      product_sku = Digest::MD5.hexdigest(product_name)

      # There is a sku, but its only shown
      # by fetching the article
      { sku:  product_sku,
        name: product_name,
        # We can actually get a better description
        # by fetching the page and reading the meta tag
        description: product_name.capitalize,
        link:        "#{domain}#{product_relative_path}",
        price:       product_price }
    end
  end
end