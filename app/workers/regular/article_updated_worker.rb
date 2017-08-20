class ArticleUpdatedWorker < Worker::Base
  def perform(article_id)
    article = Article.find(article_id)
    Elasticsearch::IndexDocumentWorker.perform_async(article_id: article_id,
                                                     operation:  :updated)

    if article.user_article_watcheds.any?
      UserArticleWatchedWorker.perform_async(article_id)
    end
  end
end
