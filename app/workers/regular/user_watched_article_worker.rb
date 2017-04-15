# When an article is updated, this task is fired.
# It checks the watched article, then add this article into
# user's notified article
class UserWatchedArticleWorker < Worker::Base
  def perform(article_id)
    article = Article
                .eager_load(:user_watched_articles)
                .find!(article_id)
    
    today = Time.now.utc.to_date
    article.user_watched_articles.each do |watched_article|
      if watched_article.all_criteria_applies?
        watched_article.notify!(today)
      end
    end
  end
end