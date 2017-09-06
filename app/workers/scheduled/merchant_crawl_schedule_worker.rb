#
class MerchantCrawlScheduleWorker < Worker::Base
  def perform
    logger.info 'Merchant Crawl Scheduler Started'
    scheduled_merchants = Merchant.all.map do |merchant|
      MerchantCrawlWorker.perform_async merchant.code
      merchant
    end

    slack_notify(text:         ':shipit: Merchant Refresh Scheduled',
                 attachments:  scheduled_merchants
                                 .map { |merchant| { title:      merchant.name.titleize,
                                                     title_link: merchant.full_url,
                                                     footer:     "#{merchant.index_pages.count} Index Pages" } },
                 unfurl_links: true)
  ensure
    logger.info 'Merchant Crawl Scheduler Completed'
  end
end
