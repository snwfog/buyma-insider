#
class MerchantCrawlScheduleWorker < Worker::Base
  def perform
    scheduled_merchants =
      Merchant.all.each do |merchant|
        MerchantCrawlWorker.perform_async merchant.code
        merchant.name
      end

    msg = scheduled_merchants.join(' ')
    Slackiq.notify(webhook_name: :worker, ':shipit: Merchant Refresh Scheduled' => msg)
  end
end
