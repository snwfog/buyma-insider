##
# Zara
#
class ZaraWorker < Worker::Base
  recurrence { daily.hour_of_day(2) }

  def initialize
    @merchant = ::Zara.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
