##
# Ssense
#
class SsenseWorker < Worker::Base
  def initialize
    @merchant = ::Ssense.new
  end

  def crawl
    @crawler = @merchant.crawl
    @stats   = @crawler.stats
  end
end
