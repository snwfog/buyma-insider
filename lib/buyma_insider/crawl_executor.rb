require 'buyma_insider/url_cache'
require 'buyma_insider/http'

class CrawlExecutor
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
      indexer.index
    end
  end

  def crawl_index_page(index_url, &block)
    begin
      if block_given?
        each_page(index_url, &block)
      else
        each_page(index_url) do |page_url|
          # Add url to cache, break if already exists
          next unless @url_cache.add? page_url

          # Get link HTML and set @response if not in url cache
          @response = Http.get page_url

          # Parse into document from response
          if @response.body.empty?
            @document = Nokogiri::HTML(@response.body)
          else
            next
          end

          items = @document.css(merchant.item_css)

          # Process items
          process(items)

          # Update current crawler statistics
          update_crawl_stats(items)
        end
      end
    rescue Exception => e
      raise e
    ensure
      # yield for merchant stats saving
      # yield self if block_given?

      # Flush crawled page cache [UrlCache]
      # flush_cache_url
    end
  end

  def process(items)
    items.each do |item_html_node|
      attrs   = @merchant.article_model.attrs_from_node(item_html_node)
      Article.upsert(attrs)
    end
  end

  def update_crawl_stats(items)
    @total_traffic_in_byte += content_length
    @total_merchant_items  += items.count
  end
end