##
# Zara
#
class ZaraWorker < Worker::Base
  # recurrence { hourly(1) }

  def initialize
    @merchant = ::Zara.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
