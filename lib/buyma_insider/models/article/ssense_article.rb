
##
# Ssense article
#
class SsenseArticle < Article
  # primary_key :sku
  def self.attrs_from_node(n)
    {
      id:          n['data-product-sku'],
      name:        n['data-product-name'],
      price:       n['data-product-price'],
      description: %Q(#{n['data-product-brand']} - #{n['data-product-name']}),
      link:        URI(%Q(#{Ssense.base_url}#{n.at_xpath('a').attributes['href']})),
      '_type':     self.to_s
    }
  end
end
