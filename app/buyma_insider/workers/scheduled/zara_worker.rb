##
# Zara
#
class ZaraWorker < CrawlerWorkerBase
  recurrence {
    daily.hour_of_day(2)
  }

  def initialize
    @merchant = Merchant::Base[:zara]
  end
end
