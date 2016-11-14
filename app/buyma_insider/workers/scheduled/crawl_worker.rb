require 'slackiq'
require 'sentry-raven'

class CrawlWorker < Worker::Base
  attr_accessor :merchant,
                :crawler,
                :stats

  def perform(merchant_code)
    log_start

    Raven.capture {
      @merchant = Merchant::Base[merchant_code]
      @crawler  = merchant.crawl
      @stats    = crawler.stats
    }

    log_end
  end

  def log_start
    logger.info "Start crawling #{merchant.name.to_s}..."
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl started..."
  end

  def log_end
    Slackiq.notify webhook_name: :worker,
                   title:        "#{merchant.name.to_s} crawl finished in #{'%.02f' % (crawler.total_elapsed_time / 60)}m.",
                   Success:      stats.fetch(true, []).count,
                   Failed:       stats.fetch(false, []).count
  end
end
