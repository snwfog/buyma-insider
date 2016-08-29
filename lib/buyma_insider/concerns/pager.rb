module Concerns
  module Pager
    def pages
      pager_css.nil? ? '' : @document.at_css(pager_css)
    end
  end
end