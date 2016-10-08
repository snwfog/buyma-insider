require 'logging'
require 'sidekiq'
require 'buyma_insider'

class ExampleWorker
  include Sidekiq::Worker

  def initialize
    @logger = Logging.logger['Worker']
  end

  def perform
    @logger.info 'Example worker performed action!'
    logger.info 'Sidekiq example worker performed!'
  end
end
