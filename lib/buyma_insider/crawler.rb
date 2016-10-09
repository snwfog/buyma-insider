require 'sentry-raven'
require 'logging'
require 'buyma_insider/url_cache'
require 'buyma_insider/http'

class Crawler
  attr_accessor :merchant
  attr_accessor :histories

  def initialize(merchant)
    @merchant  = merchant
    @logger    = Logging.logger[merchant]
    @url_cache = UrlCache.new(merchant)
    @histories = []
  end

  def crawl(&blk)
    merchant.index_pages.each do |indexer|
      history = CrawlHistory.create(
        description: "#{@merchant.to_s} '#{indexer.to_s}'",
        link:        indexer.to_s
      )

      @histories << history

      begin
        @logger.info "#{history.description} started at #{Time.now}"
        history.status = :inprogress
        history.save

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
            blk.call(history, attrs)
          end

          history.traffic_size += response.content_length
        end
        history.status = :success
      rescue Exception => ex
        history.status = :failed
        @logger.error ex
        Raven.capture_exception(ex)

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

  def total_elapsed_time
    @histories.select(&:successful?).map(&:elapsed_time).reduce(:+)
  end

  def stats
    @histories.group_by(&:successful?)
  end
end