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
  index_page 'https://www.ssense.com/en-ca/men'
  index_page 'https://www.ssense.com/en-ca/women'
  item_xpath %q(//div[@class="browsing-product-list"]//div[@class="browsing-product-item"])

  attr_reader :total_traffic_in_byte
  attr_reader :total_merchant_items

  def initialize(options={})
    @options               = options
    @total_traffic_in_byte = 0
    @total_merchant_items  = 0
  end

  ##
  # Extra pages number from the index page
  #
  def pages
  end

  def crawl
    index_pages.each do |url|
      get url # Grab the link and set @response
      parse # Parse into document from response

      @items = @document.xpath(item_xpath)
      process

      @total_traffic_in_byte += content_length
      @total_merchant_items  += @items.count
    end
  end
end
