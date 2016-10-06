module Indexer
# Ssense Indexer
  class SsenseIndexer < Base
    self.pager_css = 'div.browsing-pagination ul.nav'

    def initialize(*args, &blk)
      super(*args, &blk)
      @merchant  = Ssense
    end

    def index(&blk)
      page_nodes = index_document.at_css(self.pager_css)
      first_node = page_nodes.css('li:not(.hidden)').first
      last_node  = page_nodes.at_css('li:not(.hidden).last-page')

      first_page = first_node.content.to_i
      last_page  = last_node.at_css('a').content.to_i

      raise unless block_given?

      (first_page..last_page).each(&blk)
    end
  end
end
