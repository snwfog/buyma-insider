class ArticleUpdatedWorker < Worker::Base
  def perform(article_id)
    article = Article.find?(article_id)

    unless article
      logger.warn 'Could not find article: %s' % article_id
      return
    end

    Elasticsearch::IndexDocumentWorker.perform_async(article_id: article_id,
                                                     operation:  :update)

    if article.user_article_watcheds.any?
      UserArticleWatchedWorker.perform_async(article_id)
    end
  end
end
