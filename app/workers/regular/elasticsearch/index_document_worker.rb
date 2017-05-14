module Elasticsearch
  class IndexDocumentWorker < Worker::Base
    def perform(index, type, attributes)
      logger.info 'Index document index => %s, type => %s, attributes => %s' % [index, type, attributes]
      args = { index: index,
               type:  type }
      
      if id = attributes.delete('id')
        args[:id] = id
      end
      
      args[:body] = attributes
      $elasticsearch.index(args)
    end
  end
end
