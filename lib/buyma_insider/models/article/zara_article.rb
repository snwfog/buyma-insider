##
# Zara article
#
class ZaraArticle < Article
  def self.attrs_from_node(n)
    # {
    #   id:
    #   name:
    #   price:
    #   description:
    #   link:
    #   '_type': self.to_s
    # }
  end
end