require 'sidekiq'
require 'buyma_insider'

class SsenseWorker
  include Sidekiq::Worker

  def perform
    Ssense.new.crawl
  end
end
