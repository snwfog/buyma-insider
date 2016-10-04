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
    merchant.index_pages.each do |idx|
      crawl_index_page %Q(#{merchant.base_url}/#{idx})
    end
  end

  def each_page(index_url, &block)
    @response = ::Http.get index_url
    @document = Nokogiri::HTML(@response.body)
    indexer.index(@document, @merchant.class, &block)
  end

  def crawl_index_page(index_url)
    begin
      each_page(index_url) do |i|
        # Grab the index snapshot to compute the links
        page_url = "#{@merchant.base_url}/#{index_url}/pages/#{i}"
        puts "Processing #{page_url}".yellow

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

        # Process @items
        process(items)

        # Update current crawler statistics
        update_crawl_stats
      end
    rescue Exception => e
      raise e
    ensure
      # yield for merchant stats saving
      yield self if block_given?
      # Flush crawled page cache [UrlCache]
      flush_cache_url
    end
  end

  def process(items)

  end

  def update_crawl_stats
    @total_traffic_in_byte += content_length
    @total_merchant_items  += @items.count
  end
end