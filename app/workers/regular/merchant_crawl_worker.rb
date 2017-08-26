require 'faker'
require 'sentry-raven'

class MerchantCrawlWorker < Worker::Base
  attr_reader :merchant
  # sidekiq_options queue:     :crawl,
  #                 retry:     false,
  #                 backtrace: true
  def perform(merchant_code)
    @merchant = Merchant.find_by_code!(merchant_code)
    log_start
    @merchant.index_pages.each do |index_page|
      if index_page.is_cache_fresh? # implies has cache
        logger.info 'Index cache `%s` exists.' % index_page.cache_html_path
        logger.info 'Index cache is considered fresh, use web cache fetch if possible.'
        IndexPageCrawlWorker.perform_async(index_page_id: index_page.id,
                                           use_web_cache: true)
      else
        logger.info 'Index page cache at `%s` is not fresh or does not exists.' % index_page.cache_html_path
        logger.info 'Fetch new index page [%s].' % index_page
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
