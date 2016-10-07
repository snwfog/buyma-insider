$:.unshift(File.expand_path("lib"), File.dirname(__FILE__))

require 'sidekiq'
require 'buyma_insider'

class ExampleWorker
  include Sidekiq::Worker

  def perform
    puts "Test"
  end
end
