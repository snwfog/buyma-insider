##
# Example
#
class ExampleWorker < Worker::Base
  # recurrence { secondly(10) }
  def perform
    logger.info 'Work performed!'
  end
end
