class RethinkdbBackupWorker < Worker::Base
  # TODO
  def perform
    logger.info { 'Backing up database' }
  end
end