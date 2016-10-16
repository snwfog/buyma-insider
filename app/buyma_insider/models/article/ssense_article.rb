##
# Ssense article
#
class SsenseArticle < Article
  self.merchant_code = 'sse'

  def self.attrs_from_node(n)
    {
      id:          n['data-product-sku'],
      name:        n['data-product-name'],
      price:       n['data-product-price'],
      description: "#{n['data-product-brand']} - #{n['data-product-name']}",
      link:        "#{Ssense.base_url}#{n.at_css('a')['href']}",
      '_type':     self.to_s
    }
  end
end
