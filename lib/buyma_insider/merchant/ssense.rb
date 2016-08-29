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

  attr_reader :total_traffic_in_byte
  attr_reader :total_merchant_items

  def initialize(options={})
    @options               = options
    @total_traffic_in_byte = 0
    @total_merchant_items  = 0
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

        @items = @document.xpath(item_xpath)

        # Process @items [Processor]
        process

        @total_traffic_in_byte += content_length
        @total_merchant_items  += @items.count

        flush_cache_url
      end
    end
  end
end
