require 'colorize'
require 'awesome_print'
require 'rest_client'
require 'nokogiri'

module Merchant
  class Ssense < Base
    index_page 'https://www.ssense.com/en-ca/men'
    index_page 'https://www.ssense.com/en-ca/women'

    def initialize
      @total_traffic_in_byte = 0
      @total_merchant_items  = 0
    end

    # Extra pages number from the index page
    def pages(index_page_address)
      raw = raw_response(index_page_address)

    end

    def crawl
      index_pages.each do |address|
        raw      = raw_response(address)
        decoded  = decode_response(raw)
        response = response(decoded, raw)

        article_document = Nokogiri::HTML(response.body)
        merchant_items   = article_document.xpath %Q(//div[@class="browsing-product-list"]//div[@class="browsing-product-item"])

        @total_traffic        += raw_response.file.size
        @total_merchant_items += merchant_items.size
      end
    end
  end
end
