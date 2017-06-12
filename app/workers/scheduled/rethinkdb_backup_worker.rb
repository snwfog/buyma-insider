class RethinkdbBackupWorker < Worker::Base
  # TODO
  def perform
    logger.info 'Backing up rethinkdb database'
  end
end