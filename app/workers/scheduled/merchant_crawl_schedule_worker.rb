#
class MerchantCrawlScheduleWorker < Worker::Base
  def perform
    scheduled_merchants =
      Merchant.all.each do |merchant|
        MerchantCrawlWorker.perform_async merchant.code
        merchant.name
      end

    msg = scheduled_merchants.join(' ')
    slack_notify(text: ':shipit: Merchant Refresh Scheduled',
                 text: msg)
  end
end
