require 'logging'

class SidekiqLogging
  def initialize
    @logger = Logging.logger[:Web]
  end
  
  def call(worker, msg, queue, *args)
    @logger.info '%s scheduled ([Queue: %s] %s)' % [worker, queue, msg]
    yield
  end
end