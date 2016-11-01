module Merchant
  module Indexer
    class Shoeme < Base
      self.pager_css = 'div.nxt-pagination'

      def initialize(path, merchant_klazz)
        super("nav?initial_url=http://www.shoeme.ca/#{path}", merchant_klazz)
      end

      def compute_page
        raise unless block_given?

        page_nodes = index_document.at_css(self.pager_css)
        first_node = page_nodes.at_css('ul li:first-child')
        last_node  = page_nodes.at_css('ul li:last-child')

        first_page = first_node.at_css('span.nxt-current').content.to_i
        /page-(?<last_page>[\d]{1,10})/ =~ last_node.at_css('a.nxt-pages-next')['href']
        (first_page..last_page.to_i).each { |i| yield "#{index_url}&page=#{i}" }
      end
    end
  end
end
