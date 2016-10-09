##
# Zara
#
class Worker::ZaraWorker < Worker::Base
  def initialize
    @merchant = ::Zara.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
