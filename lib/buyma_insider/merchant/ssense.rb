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
    index_pages.each do |url|
      begin
        # Skip if cache include url
        next if cache.include? url

        # Get link HTML and set @response if not in url cache
        get %Q(#{url})

        # Cache effective url [UrlCache]
        cache_url

        # Parse into document from response [Parser]
        parse

        pages
        puts next_page
        puts prev_page

        @items = @document.xpath(item_xpath)

        # Process @items [Processor]
        process

        # Update current crawler statistics
        update_crawl_stats
      rescue Exception => e
        raise e
      ensure
        # Flush crawled page cache [UrlCache]
        flush_cache_url
      end
    end
  end

  def prev_page
    "#{self.class.base_url}#{@pg_nodes.at_css('li:first-child a').attributes['href']}"
  end

  def next_page
    "#{self.class.base_url}#{@pg_nodes.at_css('li:last-child a').attributes['href']}"
  end
end
