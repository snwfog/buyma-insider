require 'buyma_insider/url_cache'
require 'buyma_insider/http'

class Crawler
  attr_accessor :merchant

  attr_accessor :total_traffic_in_byte
  attr_accessor :total_merchant_items

  def initialize(m)
    @merchant  = m
    @url_cache = UrlCache.new(m)

    @total_traffic_in_byte = 0
    @total_merchant_items  = 0
  end

  def crawl
    merchant.index_pages.each do |indexer|
      indexer.each_page do |page_url|
        # Add url to cache, break if already exists
        next unless @url_cache.add? page_url

        # Get link HTML and set @response if not in url cache
        response = Http.get page_url

        # Parse into document from response
        next if response.body.empty?

        @document = Nokogiri::HTML(response.body)
        items = @document.css(merchant.item_css)

        # Process items
        process(items)

        @total_merchant_items  += items.count
        @total_traffic_in_byte += content_length(response)
      end
    end
  end

  def process(items)
    items.each do |item_html_node|
      attrs = @merchant.article_model
                .attrs_from_node(item_html_node)

      Article.upsert(attrs)
    end
  end

  def content_length(response)
    response.headers[:content_length] ||
      Zlib::Deflate.deflate(response.body).size # Approximate
  end
end