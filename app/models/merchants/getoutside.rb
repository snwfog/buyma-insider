module Merchants
  module Getoutside
    def self.extended(merchant)
      merchant.indexer = GetoutsideIndexer
      merchant.extend Parser
    end

    class GetoutsideIndexer < Indexer
      def compute_index_page
        # There are 2 pagers
        page_numbers = pager_node.css('li:not(.next):not(.previous)').map(&:content)
        page_numbers.map do |page_number|
          relative_path = "#{index_page.relative_path}?p=#{page_number}"
          IndexPage.new(index_page:    index_page,
                        merchant:      merchant,
                        relative_path: relative_path)
        end
      end
    end

    module Parser
      def attrs_from_node(node)
        product_image_link = node.at_css('a.product-image')
        # This is last price, which is either regular price or special price
        # we display always the last price
        price_node = node.at_css('div.price-box')
                       .at_css('p.special-price span.price', 'span.regular-price')
        article_id = price_node['id'][/[\d]{1,10}/]
        price      = (price_node.at_css('span.price') || price_node).content[/[$]?[\d]{1,10}\.[\d]{2}/]

        { sku:         article_id.strip,
          name:        product_image_link['title'].strip,
          description: node.at_css('h2.product-name a').content.strip,
          link:        product_image_link['href'],
          price:       price }
      end
    end
  end
end
