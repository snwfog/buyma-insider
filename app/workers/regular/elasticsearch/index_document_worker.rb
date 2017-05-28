module Elasticsearch
  class IndexDocumentWorker < Worker::Base
    def perform(args)
      # index, type, attributes)
      article_id = args.fetch(:article_id)
      operation  = args.fetch(:operation)
      article    = Article
                     .eager_load(:merchant)
                     .find(article_id) # Will raise unless found
      index      = article.merchant.code
      type       = :article
      # TODO: Race condition here, article might be concurrently updated
      $elasticsearch.index(index: index,
                           type:  :article,
                           body:  article.attributes.except(:id))
    end
  end
end
