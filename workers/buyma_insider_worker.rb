# $LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
# $LOAD_PATH.unshift File.expand_path('../config', File.dirname(__FILE__))
# $LOAD_PATH.unshift File.expand_path('../spec', File.dirname(__FILE__))

require 'sidekiq'
# require 'buyma_insider'

class BuymaInsiderWorker
  include Sidekiq::Worker

  def perform
    puts 'LOL'
  end
end
