class RethinkdbBackupWorker < Worker::Base
  recurrence { daily }
  
  # TODO
  def perform
    logger.info { 'Backing up database' }
  end
end