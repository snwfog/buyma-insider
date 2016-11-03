##
# Shoeme
#
class ShoemeWorker < CrawlerWorkerBase
  recurrence {
    daily
      .hour_of_day(1)
  }

  def initialize
    @merchant = Merchant::Base[:shoeme]
  end
end
