require 'set'
require 'sentry-raven'
require 'logging'

class CrawlWorker < Worker::Base
  attr_accessor :merchant
  attr_accessor :histories
  
  def initialize
    super
    
    @logger      = Logging.logger[merchant]
    @url_cache   = Set.new
    @histories   = []
    @std_headers = {
      x_forwarded_for:  Faker::Internet.ip_v4_address,
      x_forwarded_host: Faker::Internet.ip_v4_address,
      user_agent:       BuymaInsider::SPOOF_USER_AGENT,
      accept_encoding:  'gzip, deflate',
      cache_control:    'no-cache',
      pragma:           'no-cache'
    }
  end
  
  def perform(merchant_identifier)
    @merchant = MerchantMetadatum[merchant_identifier]
    
    Raven.capture {
      log_start
      
      crawl
      @stats = crawler.stats
      
      log_end
    }
  end
  
  def crawl(opts = {}, &blk)
    crawl_session = CrawlSession.create!(merchant: merchant)
    
    merchant.indices.each do |indexer|
      protocol = merchant.metadatum.ssl ? 'https' : 'http'
      history  = CrawlHistory.create(
        merchant_id:   merchant.code,
        crawl_session: crawl_session,
        description:   "#{merchant.name} '#{indexer.to_s}'",
        link:          indexer.to_s
      )
      
      @histories << history
      
      begin
        @logger.info "#{history.description} started at #{Time.now}"
        history.status = :inprogress
        history.save
        
        indexer.each_page(opts) do |page_url|
          @logger.info("Requesting page '#{page_url}'")
          
          # Add url to cache, break if already exists
          next unless @url_cache.add? page_url
          
          # Get link HTML and set @response if not in url cache
          response = RestClient.get "#{protocol}:#{page_url}"
          
          @logger.info("Received html '#{page_url}' (#{response.content_length} B)")
          
          # Parse into document from response
          next if response.body.empty?
          
          @document = Nokogiri::HTML(response.body)
          @document.css(merchant.item_css).each do |it|
            begin
              # TODO: Will fail if the parsing fail
              attrs = merchant.attrs_from_node(it).merge(merchant_id: merchant.code)
              
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
        Raven.capture_exception(ex)
        @logger.error history.description
        @logger.error ex
          # raise ex swallow error and log to sentry
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
    histories.select(&:completed?).map(&:elapsed_time).reduce(0.0, :+)
  end
  
  def stats
    histories.group_by(&:completed?)
  end
  
  def log_start
    logger.info "Start crawling #{merchant.name.to_s}..."
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl started..."
  end
  
  def log_end
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl finished in #{'%.02f' % (crawler.total_elapsed_time / 60)}m.",
                   Success:      stats.fetch(true, []).count,
                   Failed:       stats.fetch(false, []).count
  end
end

