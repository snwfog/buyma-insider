module Merchants
  module SportingLife
    def self.extended(m)
      m.indexer = SportingLifeIndexer
      m.extend Parser
    end

    class SportingLifeIndexer < Indexer
      # Top pager is picked
      # By default, there are 12 articles per page, keep it so, because
      # its the default and we don't need to keep track of an extra qs param
      def compute_index_page
        # find max page number
        last_page_number = pager_node
                             .css('a')
                             .map(&:content)
                             .reject(&:blank?)
                             .sort
                             .last

        relative_path = pager_node.css('a').map do |href_node|
          path = URI.parse(href_node['href']).path rescue nil
          path and path.gsub(/;jsessionid\=.+\z/, '')
        end.compact.last

        ('1'..last_page_number).map do |page_number|
          merchant.index_pages.build(index_page:    index_page,
                                     relative_path: "#{relative_path}?page=#{page_number}")
        end
      end
    end

    module Parser
      def attrs_from_node(node)
        product_name  = node.at_css('div.product-name a h5').content.strip.downcase
        product_desc  = product_name.capitalize
        product_price = node.at_css('div.price').content.strip[/(?<=\$)?(([\d]{1,3}),?)+\.[\d]{2}/]
        product_link  = URI(node.at_css('div.product-name a')['href'])
        product_sku   = node.at_css('div.product-name a')['class'].strip.split(/-/).last

        # cleanup relative path, it has jsessionid
        product_relative_path = product_link.path.gsub(/;jsessionid\=.+\z/, '')

        { sku:         product_sku,
          name:        product_name,
          description: product_desc,
          link:        "//#{product_link.host}#{product_relative_path}",
          price:       product_price }
      end
    end
  end
end