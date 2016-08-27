%w(lib config spec workers).each do |p|
  $:.unshift(File.expand_path("../#{p}"), File.dirname(__FILE__))
end

require 'sidekiq'
require 'buyma_insider'

class BuymaInsiderWorker
  include Sidekiq::Worker

  def perform
    Ssense.new.crawl
  end
end
