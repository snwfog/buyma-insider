##
# Ssense
#
class SsenseWorker < CrawlerWorkerBase
  recurrence {
    daily.hour_of_day(3)
  }

  def initialize
    @merchant = ::Ssense.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
