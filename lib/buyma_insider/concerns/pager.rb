module Concerns
  module Pager
    def each_page(index_url)
      @response = get index_url
      parse
      yield index_url

      until (pg = next_page).nil?
        yield pg
      end
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