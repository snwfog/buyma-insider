module Indexer
  ##
  # Process an index page and create the pages links
  ##
  class SsenseIndexer < Base
    def index(document, merchant, &block)
      page_nodes = document.at_css(merchant.pager_css)
      first_node = page_nodes.css('li:not(.hidden)').first
      last_node  = page_nodes.at_css('li:not(.hidden).last-page')

      first_page = first_node.content.to_i
      last_page  = last_node.at_css('a').content.to_i

      raise unless block_given?

      (first_page..last_page).each { |i| yield i }
    end
  end
end