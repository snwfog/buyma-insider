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
    
    article.user_article_watcheds.each do |article_watched|
      article_watched.article_notification_criteria.each do |criterium|
        if criterium.applicable?(article)
          ua_notified = UserArticleNotified
                          .upsert!(user:    article_watched.user,
                                   article: article_watched.article)
          
          UserArticleNotifiedNotificationCriterium
            .create!(user_article_notified:          ua_notified,
                     article_notification_criterium: criterium)
        end
      end
    end
  end
end