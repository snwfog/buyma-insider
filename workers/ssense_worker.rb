require 'slackiq'
require 'sidekiq'
require 'sentry-raven'
require 'buyma_insider'

class SsenseWorker
  include Sidekiq::Worker

  def perform
    Raven.capture do
      logger.info "Start crawling #{::Ssense}..."
      Slackiq.notify webhook_name: :worker,
                     title:        "Start crawling #{::Ssense}..."

      crawl       = ::Ssense.new.crawl
      crawl_stats = crawl.stats

      Slackiq.notify webhook_name: :worker,
                     title:        "Finished crawling #{::Ssense} in #{crawl.elapsed_time}s.",
                     Success:      crawl_stats.fetch(true, []).count,
                     Failed:       crawl_stats.fetch(false, []).count
    end
  end
end
