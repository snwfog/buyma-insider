module Merchant
  module Indexer
    class Ssense < Base
      def compute_page
        raise 'Indexer#compute_page should have block' unless block_given?
        page_nodes = index_document.at_css(pager_css)
        first_node = page_nodes.css('li:not(.hidden)').first
        last_node  = page_nodes.at_css('li:not(.hidden).last-page')

        first_page = first_node.content.to_i
        last_page  = last_node.at_css('a').content.to_i

        (first_page..last_page).each { |i| yield "#{index_url}/pages/#{i}" }
      end
    end
  end
end
