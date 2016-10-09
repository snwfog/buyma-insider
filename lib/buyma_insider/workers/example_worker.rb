require 'sidekiq'
require 'sidetiq'

##
# Example
#
class Worker::ExampleWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { secondly(10) }

  def perform
    logger.info "Worked performed!"
  end
end
