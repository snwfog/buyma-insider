require 'sentry-raven'
require 'logging'
require 'buyma_insider/url_cache'
require 'buyma_insider/http'

class Crawler
  attr_accessor :merchant_klazz
  attr_accessor :histories

  def initialize(merchant_klazz)
    @merchant_klazz = merchant_klazz
    @logger         = Logging.logger[merchant_klazz]
    @url_cache      = UrlCache.new
    @histories      = []
  end

  def crawl(&blk)
    merchant_klazz.index_pages.each do |indexer|
      history = CrawlHistory.create(
        merchant_id: merchant_klazz.code,
        description: "#{merchant_klazz.to_s} '#{indexer.to_s}'",
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

          @logger.info("Received html '#{page_url}' (#{response.content_length} B)")

          # Parse into document from response
          next if response.body.empty?

          @document = Nokogiri::HTML(response.body)
          @document.css(merchant_klazz.item_css).each do |it|
            begin
              # TODO: Will fail if the parsing fail
              attrs = merchant_klazz.attrs_from_node(it)
              # IMPT: Just yield the attrs hash
              blk.call(history, attrs)
            rescue Exception => ex
              @logger.warn 'Failed parsing merchant item'
              @logger.warn it.to_html
              @logger.warn ex
            ensure
              @logger.debug attrs
            end
          end

          history.traffic_size += response.content_length
        end
        history.status = :completed
      rescue Exception => ex
        history.status = :aborted
        @logger.error history.description
        @logger.error ex
        Raven.capture_exception(ex)
      ensure
        history.finished_at = Time.now.utc
        history.save

        @logger.info <<~EOF
          #{history.description} finished at #{Time.now} (#{'%.02f' % history.elapsed_time}s) with #{history.status}
                              [Total items: #{history.items_count}, Traffic size: #{history.traffic_size}B]\n
        EOF
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