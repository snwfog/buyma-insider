require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/calculations'

#
class MerchantCrawlScheduleWorker < Worker::Base
  def perform
    scheduled_merchants = []
    Merchant.each do |merchant|
      MerchantCrawlWorker.perform_async merchant.id
      scheduled_merchants << merchant.name
    end

    msg = scheduled_merchants.map { |name| "`#{name}`" }.join(' ')
    Slackiq.notify(webhook_name: :worker, ':shipit: Merchant Refresh Scheduled' => msg)
  end
end
