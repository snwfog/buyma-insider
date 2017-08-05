require 'faker'
require 'sentry-raven'

class MerchantCrawlWorker < Worker::Base
  attr_reader :merchant
  # sidekiq_options queue:     :crawl,
  #                 retry:     false,
  #                 backtrace: true
  def perform(merchant_id)
    @merchant           = Merchant.find!(merchant_id)
    @merchant_cache_dir = File.expand_path("#{BuymaInsider.app_path}/tmp/cache/crawl/#{@merchant.id}")
    FileUtils::mkdir_p(@merchant_cache_dir) unless File::directory?(@merchant_cache_dir)

    log_start
    @merchant.index_pages.each do |index_page|
      index_page_cache_path = @merchant_cache_dir + '/' + index_page.cache_filename
      if File::exist?(index_page_cache_path) and ((index_page_cache_mtime = File::mtime(index_page_cache_path)) >= 1.weeks.ago)
        logger.info 'Index cache `%s` exists' % index_page_cache_path
        logger.info 'Index cache is less than a week old, try use etag header'
        IndexPageCrawlWorker.perform_async(index_page_id: index_page.id, lazy: true)
      else
        if index_page_cache_mtime
          logger.info 'Index cache is over a week old, last modified at %s' % index_page_cache_mtime
        else
          logger.info 'Index cache does not exists, creating a new cache copy at %s' % index_page_cache_path
        end

        IndexPageCrawlWorker.perform_async(index_page_id: index_page.id)
      end
    end
    log_end

  end

  def log_start
    logger.info 'Start crawling %s...' % @merchant.name
    Slackiq.notify(webhook_name: :worker,
                   title:        "#{@merchant.name} crawl started, scheduling all index pages to be updated.")
  end

  def log_end
    logger.info 'Finished crawling %s...' % @merchant.name
    Slackiq.notify(webhook_name: :worker,
                   title:        "#{@merchant.name} index pages has been scheduled.")
  end

end
