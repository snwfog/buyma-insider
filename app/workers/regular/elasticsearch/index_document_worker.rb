module Elasticsearch
  class IndexDocumentWorker < Worker::Base
    def perform(args)
      article_id = args.fetch('article_id')
      operation  = args.fetch('operation')
      article    = Article.eager_load(:merchant).find(article_id)

      index = article.merchant.code
      type  = :article
      # TODO: Race condition, article might be concurrently updated
      case operation
      when 'created', 'updated'
        logger.info "Indexing elasticsearch article `#{article.name}'."
        article_attributes = article.attributes.except('id', 'merchant_id', 'image_link')
        $elasticsearch.index index: index,
                             type:  type,
                             id:    article.id,
                             body:  article_attributes
      when 'destroyed'
        # Not yet supported
      else
        raise 'Unsupported elasticsearch index operation `%s`' % operation
      end
    end
  end
end
