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
      if article_watched.all_criteria_apply?
        UserArticleNotified.create!(user:        article_watched.user,
                                    article:     article_watched.article,
                                    notified_at: today)
      end
    end
  end
end