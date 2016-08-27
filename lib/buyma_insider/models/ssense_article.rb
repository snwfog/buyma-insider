##
# AR for an article
class SsenseArticle < Article
  # primary_key :sku

  class << self
    def from_node(item_node)
      article = new(
        id:          item_node['data-product-sku'],
        name:        item_node['data-product-name'],
        price:       item_node['data-product-price'],
        description: %Q(#{item_node['data-product-brand']} #{item_node['data-product-name']}),
      )

      link         = item_node.at_xpath('a').attributes['href']
      link         = %Q(#{Ssense.base_url}#{link})
      article.link = link
      article
    end
  end
end
