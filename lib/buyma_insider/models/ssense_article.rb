##
# AR for an article
class SsenseArticle < Article
  # primary_key :sku

  class << self
    def attrs_from_node(n)
      {
        id:          n['data-product-sku'],
        name:        n['data-product-name'],
        price:       n['data-product-price'],
        description: %Q(#{n['data-product-brand']} - #{n['data-product-name']}),
        link:        %Q(#{Ssense.base_url}#{n.at_xpath('a').attributes['href']}),
        '_type':     self.to_s
      }
    end

    def from_node(item_node)
      new(attrs_from_node(item_node))
    end
  end
end
