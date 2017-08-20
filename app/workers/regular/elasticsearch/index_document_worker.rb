module Elasticsearch
  class IndexDocumentWorker < Worker::Base
    def perform(args)
      # index, type, attributes)
      article_id = args.fetch('article_id')
      operation  = args.fetch('operation')
      article    = Article.eager_load(:merchant).find(article_id)

      logger.info "Indexing elasticsearch article `#{article.name}'."

      index = article.merchant.code
      type  = :article
      # TODO: Race condition here, article might be concurrently updated
      case operation
      when /created/
      when /updated/
        article_attributes = article.attributes.except('id', 'merchant_id')
        $elasticsearch.index index: index,
                             type:  type,
                             id:    article.id,
                             body:  article_attributes
      when /destroyed/
        # Not yet supported
      else
        raise 'Unsupported elasticsearch index operation `%s`' % operation
      end
    end
  end
end
