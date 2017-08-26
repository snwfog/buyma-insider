#
class MerchantCrawlScheduleWorker < Worker::Base
  def perform
    scheduled_merchants = []
    Merchant.all.each do |merchant|
      MerchantCrawlWorker.perform_async merchant.code
      scheduled_merchants << merchant.name
    end

    msg = scheduled_merchants.map { |name| "`#{name}`" }.join(' ')
    Slackiq.notify(webhook_name: :worker, ':shipit: Merchant Refresh Scheduled' => msg)
  end
end
