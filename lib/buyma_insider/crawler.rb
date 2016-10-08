require 'logging'
require 'buyma_insider/url_cache'
require 'buyma_insider/http'

class Crawler
  attr_accessor :merchant

  def initialize(merchant)
    @merchant  = merchant
    @logger    = Logging.logger[merchant]
    @url_cache = UrlCache.new(merchant)
  end

  def crawl(&blk)
    merchant.index_pages.each do |indexer|
      history = CrawlHistory.create(description: "#{@merchant.to_s} '#{indexer.to_s}'")
      begin
        @logger.info "#{history.description} started at #{Time.now}"
        indexer.each_page do |page_url|
          @logger.info("Requesting page '#{page_url}'")

          # Add url to cache, break if already exists
          next unless @url_cache.add? page_url

          # Get link HTML and set @response if not in url cache
          response = Http.get "http:#{page_url}"

          # Parse into document from response
          next if response.body.empty?

          @document = Nokogiri::HTML(response.body)
          @document.css(merchant.item_css).each do |it|
            @logger.debug it.to_html
            attrs = @merchant.article_model.attrs_from_node(it)
            # IMPT: Just yield the attrs hash
            @logger.debug attrs
            blk.call(attrs)

            history.items_count += 1
          end

          history.traffic_size += response.content_length
        end
        history.status = :success
      rescue Exception => ex
        history.status = :failed
        @logger.error ex
        raise ex
      ensure
        history.finished_at = Time.now.utc
        history.save

        @logger.info "#{history.description} finished at #{Time.now}"
        @logger.info <<~HISTORY
          #{history.description} crawl finished with #{history.status} in #{history.elapsed_time}s
        HISTORY
        @logger.info "[Total items: #{history.items_count}, Traffic size: #{history.traffic_size}B]"
      end
    end
  end
end