class CrawlExecutor
  include Concerns::Http
  include Concerns::Parser
  include Concerns::Processor
  include Concerns::UrlCache
  include Concerns::Pager

  attr_accessor :merchant

  attr_accessor :total_traffic_in_byte
  attr_accessor :total_merchant_items

  def initialize(merchant)
    @merchant              = merchant
    @total_traffic_in_byte = 0
    @total_merchant_items  = 0
  end

  def crawl(index_url)
    begin
      each_page(index_url) do |pg_url|
        puts "Processing #{pg_url}".yellow
        # Break if the pg_url is in the cache
        break if cache.include? pg_url
        # Get link HTML and set @response if not in url cache
        @response = get pg_url
        # Cache effective url [UrlCache]
        cache_url
        # Parse into document from response [Parser]
        parse
        @items = @document.css(merchant.item_css)
        # Process @items [Processor]
        process
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

  def update_crawl_stats
    @total_traffic_in_byte += content_length
    @total_merchant_items  += @items.count
  end
end