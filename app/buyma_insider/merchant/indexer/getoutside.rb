module Merchant
  module Indexer
    class Getoutside < Base
      self.pager_css = 'div.pager'

      def compute_page
        raise unless block_given?
        page_nodes = index_document.at_css(self.pager_css)

        first_node = page_nodes.at_css('ol li:first-child')
        last_node  = page_nodes.css('ol li:not(.next)').last

        first_page = first_node.content.to_i
        last_page  = last_node.at_css('a').content.to_i

        (first_page..last_page).each { |i| yield "#{index_url}?p=#{i}" }
      end
    end
  end
end
