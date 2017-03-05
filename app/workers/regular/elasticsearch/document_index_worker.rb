module Elasticsearch
  class DocumentIndexWorker < Worker::Base
    def perform(model)
      logger.info 'Syncing elasticsearch with %s' % model.to_h
    end
  end
end
