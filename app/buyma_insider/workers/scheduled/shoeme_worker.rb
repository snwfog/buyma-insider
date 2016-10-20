##
# Shoeme
#
class ShoemeWorker < CrawlerWorkerBase
  recurrence {
    daily
      .hour_of_day(1)
  }

  def initialize
    @merchant = ::Shoeme.new
  end
end
