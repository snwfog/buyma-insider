# When an article is updated, this task is fired.
# It checks the watched article, then add this article into
# user's notified article
class UserArticleWatchedWorker < Worker::Base
  def perform(article_id)
    article = Article
                .eager_load(:user_article_watcheds)
                .find?(article_id)

    unless article
      logger.warn { 'Could not find article: %s' % article_id }
      return
    end
    
    today = Time.now.utc.to_date
    article.user_article_watcheds.each do |article_watched|
      if article_watched.all_criteria_applies?
        article_watched.notify!(today)
      end
    end
  end
end