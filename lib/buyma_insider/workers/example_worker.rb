require 'sidekiq'
require 'sidetiq'

##
# Example
#
class ExampleWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # recurrence { secondly(10) }
  def perform
    logger.info 'Work performed!'
  end
end
