# @deprecated
module Concerns
  module Pager
    def each_page(index_url, &block)
      @response = get index_url
      Processor::IndexProcessor.process(Nokogiri::HTML(@response.body), self, &block)
    end

    def pages
      @document.at_css(merchant.pager_css)
    end

    def next_page
      if (last_pg_node = pages.at_css('li:last-child a')).nil?
        ''
      else
        "#{merchant.base_url}#{last_pg_node.attributes['href']}"
      end
    end
  end
end