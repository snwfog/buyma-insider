require 'slackiq'
require 'sentry-raven'

class CrawlerWorkerBase < Worker::Base
  attr_accessor :merchant
  attr_accessor :crawler
  attr_accessor :stats

  def perform
    log_start

    Raven.capture { crawl }

    log_end
  end

  def crawl
    @crawler = merchant.crawl
    @stats   = crawler.stats
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
