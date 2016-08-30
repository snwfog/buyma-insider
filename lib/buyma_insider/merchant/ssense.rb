require 'table_print'
require 'colorize'
require 'awesome_print'
require 'rest_client'
require 'nokogiri'

##
# Store merchant information
##
class Ssense < Merchant::Base
  base_url 'https://www.ssense.com'
  # index_page 'http://www.google.com'
  index_page 'https://www.ssense.com/en-ca/men/'
  index_page 'https://www.ssense.com/en-ca/women'

  item_css %q(div.browsing-product-list div.browsing-product-item)
  pager_css %q(div.browsing-pagination ul.nav)

  def initialize(options={})
    super(options)
    @exec = CrawlExecutor.new(self)
  end

  def crawl
    index_pages.each do |index_url|
      @exec.crawl(index_url) do |exec|
        puts exec.total_traffic_in_byte
        puts exec.total_merchant_items
      end
    end
  end

  # def prev_page
  #   "#{self.class.base_url}#{@pg_nodes.at_css('li:first-child a').attributes['href']}"
  # end

  def next_page
    if (last_pg_node = pages.at_css('li:last-child a')).nil?
      ''
    else
      # BUG: Infinite loop here if the page is in the cache and cannot grab the next one
      "#{self.class.base_url}#{last_pg_node.attributes['href']}"
    end
  end
end
