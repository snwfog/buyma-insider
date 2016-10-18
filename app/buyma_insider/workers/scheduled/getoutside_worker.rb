##
# Getoutside
#
class GetoutsideWorker < CrawlerWorkerBase
  recurrence {
    daily
      .hour_of_day(2)
      .minute_of_hour(30)
  }

  def initialize
    @merchant = ::Getoutside.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
