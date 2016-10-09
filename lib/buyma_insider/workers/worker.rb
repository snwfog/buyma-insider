require 'sidekiq'
require 'slackiq'
require 'sentry-raven'

module Worker
  class Base
    include Sidekiq::Worker
    include Sidetiq::Schedulable

    def perform
      log_start

      Raven.capture { crawl }

      log_end
    end

    def crawl
      raise 'Not implemented'
    end

    def log_start
      logger.info "Start crawling #{@merchant.class.to_s}..."
      Slackiq.notify webhook_name: :worker,
                     title:        "Start crawling #{@merchant.class.to_s}..."
    end

    def log_end
      Slackiq.notify webhook_name: :worker,
                     title:        "Finished crawling #{@merchant.class.to_s} in #{@crawl.elapsed_time}s.",
                     Success:      crawl_stats.fetch(true, []).count,
                     Failed:       crawl_stats.fetch(false, []).count
    end
  end
end