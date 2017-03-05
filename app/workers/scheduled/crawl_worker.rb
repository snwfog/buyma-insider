require 'set'
require 'faker'
require 'sentry-raven'

class CrawlWorker < Worker::Base
  attr_accessor :merchant
  attr_accessor :histories
  
  def initialize
    super
    
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
  
  def perform(merchant_id)
    @merchant = Merchant.find!(merchant_id)
    Raven.capture do
      log_start
      
      crawl
      
      log_end
    end
  end
  
  def crawl
    crawl_session = CrawlSession.create!(merchant: merchant)
    
    merchant.indices.each do |indexer|
      protocol = merchant.metadatum.ssl ? 'https' : 'http'
      history  = CrawlHistory.create!(
        merchant:      merchant,
        crawl_session: crawl_session,
        description:   "#{merchant.name} '#{indexer.to_s}'",
        link:          indexer.to_s
      )
      
      histories << history
      
      begin
        logger.info("#{history.description} started at #{Time.now}")
        history.inprogress!
        history.save
        
        indexer.each_page do |page_url|
          logger.info("Requesting page '#{page_url}'")
          
          # Add url to cache, break if already exists
          next unless @url_cache.add? page_url
          
          # Get link HTML and set @response if not in url cache
          response = RestClient.get "#{protocol}:#{page_url}", @std_headers
          
          logger.info("Received html '#{page_url}' (#{response.content_length} B)")
          
          # Parse into document from response
          next if response.body.empty?
          
          document = Nokogiri::HTML(response.body)
          document.css(merchant.item_css).each do |it|
            begin
              # TODO: Will fail if the parsing fail
              attrs            = merchant.attrs_from_node(it)
              article          = Article.upsert!(attrs)
              article.merchant = merchant
              article.save
              
              history.items_count += 1
            rescue Exception => ex
              history.invalid_items_count += 1
              
              logger.warn 'Failed parsing a merchant item'
              logger.warn it.to_html
              logger.warn ex
            ensure
              logger.debug attrs
            end
          end
          
          history.traffic_size_kb += (response.content_length / 1000.0)
        end
      rescue Exception => ex
        history.aborted!
        # raise ex swallow error and log to sentry
        Raven.capture_exception(ex)
        logger.error history.description
        logger.error ex
        if ex.is_a? RestClient::Exception
          logger.error ex.http_headers
        end
        logger.error ex.backtrace
      else
        history.completed!
      ensure
        history.finished_at = Time.now.utc
        history.save
        
        logger.info <<~EOF
          #{history.description} finished at #{Time.now} (#{'%.02f' % history.elapsed_time_s}s) with #{history.status}
        EOF
      end
    end
  end
  
  def total_elapsed_time
    histories.select(&:completed?).map(&:elapsed_time_s).reduce(0.0, :+)
  end
  
  def stats
    histories.group_by(&:completed?)
  end
  
  def log_start
    logger.info 'Start crawling %s...' % merchant.name
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl started..."
  end
  
  def log_end
    logger.info 'Finished crawling %s...' % merchant.name
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl finished in #{'%.02f' % (total_elapsed_time / 60)}m.",
                   success:      stats.fetch(true, []).count,
                   failed:       stats.fetch(false, []).count
  end
end

