class ArticleCreatedWorker < Worker::Base
  def perform(article_id)
    article = Article.find(article_id)
    Elasticsearch::IndexDocumentWorker.perform_async(article_id: article_id,
                                                     operation:  :create)
  end
end
