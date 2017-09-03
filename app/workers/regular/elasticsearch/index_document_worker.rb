module Elasticsearch
  class IndexDocumentWorker < Worker::Base
    def perform(args)
      article_id = args.fetch('article_id')
      operation  = args.fetch('operation')
      article    = Article.eager_load(:merchant).find(article_id)

      # TODO: Race condition, article might be concurrently updated
      case operation
      when 'created', 'updated'
        logger.info "Indexing elasticsearch article `#{article.name}'."
        article_attributes = article.attributes.except('id', 'merchant_id', 'image_link')
        $elasticsearch.with do |conn|
          conn.index index: article.merchant.code,
                     type:  :article,
                     id:    article.id,
                     body:  article_attributes
        end
      when 'destroyed'
        # Not yet supported
      else
        raise 'Unsupported elasticsearch index operation `%s`' % operation
      end
    end
  end
end
