require 'sidekiq'
require 'buyma_insider'

class ZaraWorker
  include Sidekiq::Worker

  def perform
    logger.info "Start crawling #{Zara}"
    ::Zara.new.crawl
  end
end
