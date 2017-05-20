require 'faker'
require 'sentry-raven'

class CrawlWorker < Worker::Base
  attr_reader :merchant
  attr_reader :crawl_session
  
  def initialize
    super
    
    @std_headers = {
      x_forwarded_for:  Faker::Internet.ip_v4_address,
      x_forwarded_host: Faker::Internet.ip_v4_address,
      user_agent:       BuymaInsider::SPOOF_USER_AGENT,
      accept_encoding:  'gzip',
      cache_control:    'no-cache',
      pragma:           'no-cache'
    }
  
  end
  
  def perform(merchant_id)
    @merchant  = Merchant.find!(merchant_id)
    @cache_dir = "./tmp/cache/crawl/#{merchant.id}"
    FileUtils.mkdir(@cache_dir) unless File.directory?(@cache_dir)
    
    Raven.capture do
      log_start
      
      crawl
      
      log_end
    end
  end
  
  def crawl
    @crawl_session = CrawlSession.create!(merchant: merchant)
    
    merchant.index_pages.each do |index_page|
      cached_filepath = '%s/%s' % [@cache_dir, index_page.cache_filename]
      
      begin
        last_history    = CrawlHistory.where(index_page: index_page).first
        current_history = CrawlHistory.create!(index_page:    index_page,
                                               crawl_session: crawl_session,
                                               status:        :inprogress,
                                               description:   "#{merchant.name} '#{index_page}'")
        
        logger.info { '%s started at %s' % [current_history.description, Time.now] }
        current_headers = @std_headers.dup
        if File::exist?(cached_filepath) && test(?C, cached_filepath) >= 1.weeks.ago
          if last_history&.etag && !last_history&.weak?
            current_headers[:if_none_match] = last_history.etag
          end
        end
        
        begin
          raw_tempfile = fetch_page(index_page.full_url,
                                    merchant.meta.ssl?,
                                    current_headers)
        rescue RestClient::NotModified
          current_history.update!(traffic_size_kb:  0.0,
                                  response_headers: last_history.headers,
                                  response_code:    :not_modified)
          
          FileUtils.touch(cached_filepath)
        else
          current_history.update!(traffic_size_kb:  raw_tempfile.file.size / 1000.0,
                                  response_headers: raw_tempfile.headers.to_h,
                                  response_code:    :ok)
          
          FileUtils.cp(raw_tempfile.file.path, cached_filepath)
        ensure
          current_history.save!
        end
        
      rescue Exception => ex
        current_history.aborted!
        # raise ex swallow error and log to sentry
        Raven.capture_exception(ex)
        logger.error current_history.description
        logger.error ex
        if ex.is_a? RestClient::Exception
          logger.error ex.http_headers
        end
        logger.error ex.backtrace
      else
        current_history.completed!
      ensure
        current_history.finished_at = Time.now.utc.iso8601
        current_history.save!
        
        logger.info { 'Crawling %s finished at %s' % [current_history.description, Time.now] }
        logger.info { current_history.attributes }
      end
    end
  ensure
    @crawl_session.finished_at = Time.now.utc.iso8601
    @crawl_session.save!
  end
  
  def total_elapsed_time
    crawl_session.elapsed_time_s
  end
  
  def stats
    crawl_session.crawl_histories.group_by(&:completed?)
  end
  
  def log_start
    logger.info { 'Start crawling %s...' % merchant.name }
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name} crawl started..."
  end
  
  def log_end
    logger.info { 'Finished crawling %s...' % merchant.name }
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name} crawl finished in #{'%.02f' % (total_elapsed_time / 60)}m.",
                   success:      stats.fetch(true, []).count,
                   failed:       stats.fetch(false, []).count
  end
  
  private
  
  def fetch_page(uri, verify_ssl, retries = 3, **headers)
    retry_count = 0
    begin
      logger.info { "`GET` #{uri}" }
      RestClient::Request.execute(url:          uri,
                                  method:       :get,
                                  verify_ssl:   verify_ssl,
                                  raw_response: true,
                                  headers:      headers)
    rescue OpenSSL::SSL::SSLError
      retry_count += 1
      retry if retry_count <= retries
      nil
    end
  end
end


