##
# Ssense
#
class SsenseWorker < CrawlerWorkerBase
  recurrence {
    daily.hour_of_day(3)
  }

  def initialize
    @merchant = Merchant::Base[:ssense]
  end
end
