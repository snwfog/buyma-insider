require 'sidekiq'
require 'buyma_insider'

class SsenseWorker
  include Sidekiq::Worker

  def perform
    logger.info "Start crawling #{::Ssense}"
    ::Ssense.new.crawl
  end
end
