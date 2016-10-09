require 'sidekiq'

##
# Example
#
class Worker::ExampleWorker
  include Sidekiq::Worker

  def perform
    logger.info "Worked performed!"
  end
end
