##
# Ssense
#
class SsenseWorker < Worker::Base
  def initialize
    @merchant = ::Sense.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
