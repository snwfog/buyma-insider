require 'faker'
require 'sentry-raven'

class MerchantCrawlWorker < Worker::Base
  attr_reader :merchant
  # sidekiq_options queue:     :crawl,
  #                 retry:     false,
  #                 backtrace: true
  def perform(merchant_code)
    @merchant = Merchant.find_by_code!(merchant_code)
    @merchant.index_pages.each do |index_page|
      if index_page.cache.fresh? # implies has cache
        logger.info 'Index cache `%s` exists.' % index_page.cache.path
        logger.info 'Index cache is considered fresh, use web cache fetch if possible.'
        IndexPageCrawlWorker.perform_async(index_page_id:         index_page.id,
                                           perform_async_parsing: true,
                                           use_web_cache:         true)
      else
        logger.info 'Index page cache at `%s` is not fresh or does not exists.' % index_page.cache.path
        logger.info 'Fetch new index page [%s].' % index_page
        IndexPageCrawlWorker.perform_async(index_page_id:         index_page.id,
                                           perform_async_parsing: true)
      end
    end
  end
end
