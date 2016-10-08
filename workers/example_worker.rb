require 'logging'
require 'sidekiq'
require 'buyma_insider'

class ExampleWorker
  include Sidekiq::Worker

  def initialize
    @logger = Logging.logger['worker']
  end

  def perform
    @logger.info 'test' => 'one'
    @logger.debug "This should not be logged"
  end
end
