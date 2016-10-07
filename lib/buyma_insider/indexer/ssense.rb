module Indexer
# Ssense Indexer
  class Ssense < Base
    self.pager_css = 'div.browsing-pagination ul.nav'

    def compute_page
      raise unless block_given?

      page_nodes = index_document.at_css(self.pager_css)
      first_node = page_nodes.css('li:not(.hidden)').first
      last_node  = page_nodes.at_css('li:not(.hidden).last-page')

      first_page = first_node.content.to_i
      last_page  = last_node.at_css('a').content.to_i

      (first_page..last_page).each { |i|
        yield "#{index.to_s}/pages/#{i}"
      }
    end
  end
end
