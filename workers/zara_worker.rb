require 'sidekiq'
require 'slackiq'
require 'sentry-raven'
require 'buyma_insider'

class ZaraWorker
  include Sidekiq::Worker

  def perform
    Raven.capture do
      logger.info "Start crawling #{Zara}..."
      Slackiq.notify webhook_name: :worker,
                     title:        "Start crawling #{::Zara}..."

      crawl       = ::Zara.new.crawl
      crawl_stats = crawl.stats

      Slackiq.notify webhook_name: :worker,
                     title:        "Finished crawling #{::Zara} in #{crawl.elapsed_time}s.",
                     Success:      crawl_stats.fetch(true, []).count,
                     Failed:       crawl_stats.fetch(false, []).count
    end
  end
end
