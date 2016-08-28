%w(lib config spec workers).each do |p|
  $:.unshift(File.expand_path("#{p}"), File.dirname(__FILE__))
end

puts $:

require 'sidekiq'
require 'buyma_insider'

# TODO: BUG: Models update are not concurrently safe
class BuymaInsiderWorker
  include Sidekiq::Worker

  def perform
    Ssense.new.crawl
  end
end
