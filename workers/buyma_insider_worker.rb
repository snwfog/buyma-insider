require 'sidekiq'
require 'buyma_insider'

class BuymaInsiderWorker
  include Sidekiq::Worker

  def perform
    Merchant::Ssense.crawl
  end
end
