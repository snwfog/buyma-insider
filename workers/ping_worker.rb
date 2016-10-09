require 'sidekiq'
require 'sidetiq'
require 'buyma_insider'

class PingWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { secondly(10) }

  def perform
    logger.info "Worked performed!"
  end
end
