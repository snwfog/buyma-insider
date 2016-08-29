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

  item_xpath %q(//div[@class="browsing-product-list"]//div[@class="browsing-product-item"])
  pager_css %q(div.browsing-pagination ul.nav)

  attr_reader :total_traffic_in_byte
  attr_reader :total_merchant_items

  def initialize(options={})
    @options               = options
    @total_traffic_in_byte = 0
    @total_merchant_items  = 0
  end

  def update_crawl_stats
    @total_traffic_in_byte += content_length
    @total_merchant_items  += @items.count
  end

  def crawl
    index_pages.each do |index_url|
      begin
        each_pages(index_url) do |pg_url|
          # Skip if cache include url
          next if cache.include? pg_url
          # Get link HTML and set @response if not in url cache
          @response = get pg_url
          # Cache effective url [UrlCache]
          cache_url
          # Parse into document from response [Parser]
          parse
          @items = @document.xpath(item_xpath)
          # Process @items [Processor]
          process
          # Update current crawler statistics
          update_crawl_stats
        end
      rescue Exception => e
        raise e
      ensure
        # Flush crawled page cache [UrlCache]
        flush_cache_url
      end
    end
  end

  def each_pages(index_url)
    # If response is nil, then its the index page...
    # BUG: This could be run twice, also within loop
    if index_pages.include?(index_url)
      @response = get index_url if @response.nil?
      parse
      yield index_url
    end

    until (pg = next_page).nil?
      yield pg
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
