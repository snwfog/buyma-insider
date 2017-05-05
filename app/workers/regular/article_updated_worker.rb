class ArticleUpdatedWorker < Worker::Base
  def perform(article_id)
    article = Article
                .eager_load(:price_history)
                .find?(article_id)
    
    unless article
      logger.warn { 'Could not find article: %s' % article_id }
      return
    end
    
    if article.user_article_watcheds.any?
      UserArticleWatchedWorker.perform_async(article.id)
    end
  end
end