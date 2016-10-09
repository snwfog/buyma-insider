require 'sidekiq'
require 'sidetiq'
require 'slackiq'
require 'sentry-raven'

module Worker
  class Base
    include ::Sidekiq::Worker
    include ::Sidetiq::Schedulable

    attr_accessor :merchant
    attr_accessor :crawler
    attr_accessor :stats

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
                     title:        "Finished crawling #{@merchant.class.to_s} in #{@crawler.total_elapsed_time}s.",
                     Success:      @stats.key?(true) ? @stats[true].map(&:link).join('\n') : 'None',
                     Failed:       @stats.key?(false) ? @stats[false].map(&:link).join('\n') : 'None'
    end
  end
end