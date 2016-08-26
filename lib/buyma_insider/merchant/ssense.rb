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

    def crawl
      index_pages.each do |address|
        get address # Grab the link and set @response
        article_document = Nokogiri::HTML(@response.body)
        merchant_items   = article_document.xpath %q(//div[@class="browsing-product-list"]//div[@class="browsing-product-item"])

        @total_traffic_in_byte += raw_size
        @total_merchant_items  += merchant_items.size

        puts %Q(#{@total_traffic_in_byte} B, #{@total_merchant_items} Items).blue
      end
    end
  end
end
