require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/calculations'

##
# Will take all the merchant crawler,
# compute the average of the current time they takes
# to run, then schedule them so they can
# finish on time, e.g. before 6 a.m.
#
class MerchantCrawlScheduleWorker < Worker::Base
  def initialize
    @start_time = Time.now.beginning_of_day.tomorrow + 1.hour
  end
  
  def perform
    Merchant.each do |merchant|
      MerchantCrawlWorker.perform_async merchant.id
      Slackiq.notify(webhook_name: :worker,
                     title:        '%s crawler scheduled' % merchant.name.capitalize)
    end
  end
end
