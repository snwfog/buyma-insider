require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/calculations'

##
#
# Will take all the merchant crawler,
# compute the average of the current time they takes
# to run, then schedule them so they can
# finish on time, e.g. before 6 a.m.
#
class CrawlScheduleWorker < Worker::Base
  def initialize
    @start_time = Time.now.beginning_of_day.tomorrow + 1.hour
  end
  
  def perform
    merchant_crawl_time = Merchant.all.map do |merchant|
      elapsed_time_s_last_10 = merchant.crawl_sessions.limit(10).map(&:elapsed_time_s)
      avg_time_s             = if elapsed_time_s_last_10.empty?
                                 0.0
                               else
                                 elapsed_time_s_last_10.inject(0.0, :+) / elapsed_time_s_last_10.size
                               end
      [merchant, avg_time_s]
    end
    
    merchant_crawl_time = merchant_crawl_time.sort_by(&:last) # sort_by array's last, which is the elapsed time
    merchant_crawl_time.each do |merchant, _elapsed_time|
      CrawlWorker.perform_at @start_time, merchant.id
      Slackiq.notify webhook_name: :worker,
                     title:        %(#{merchant.name.capitalize} crawler scheduled to start @ #{@start_time.strftime('%F %T')})
      
      @start_time += 30.minutes
    end
  end
end
