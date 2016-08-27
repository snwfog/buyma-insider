require 'table_print'
require 'colorize'
require 'awesome_print'
require 'rest_client'
require 'nokogiri'

module Merchant
  ##
  # Store merchant information
  ##
  class Ssense < Base
    index_page 'https://www.ssense.com/en-ca/men'
    index_page 'https://www.ssense.com/en-ca/women'

    def initialize(options={})
      @options               = options
      @total_traffic_in_byte = 0
      @total_merchant_items  = 0
    end

    # Extra pages number from the index page
    def pages(index_page_address)
      raw = raw_response(index_page_address)
    end

    # Probe the client
    def probe

    end

    def item_path
      %q(//div[@class="browsing-product-list"]//div[@class="browsing-product-item"])
    end

    def crawl
      index_pages.each do |url|
        get url # Grab the link and set @response
        parse # Parse into document from response

        items = document.xpath(item_path)

        @total_traffic_in_byte += content_length
        @total_merchant_items  += items.size

        puts %Q(#{@total_traffic_in_byte} B).blue
        puts %Q(#{@total_merchant_items} Items).blue
      end
    end
  end
end
