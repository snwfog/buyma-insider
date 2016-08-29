module Concerns
  module Pager
    def pages
      return nil if pager_css.nil?
      @pg_nodes ||= @document.at_css(pager_css)
      Enumerator.new do |pg|
        pg.yield next_page unless next_page.nil?
      end
    end
  end
end