class ArticleUpdatedWorker < Worker::Base
  def perform(article_id)
    article = Article.find?(article_id)
    
    unless article
      logger.warn { 'Could not find article: %s' % article_id }
      return
    end
    
    Elasticsearch::IndexDocumentWorker.perform_async(article.to_h, Article)
    
    if article.user_article_watcheds.any?
      UserArticleWatchedWorker.perform_async(article.id)
    end
  end
end