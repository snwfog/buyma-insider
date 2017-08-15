class UserArticleWatchedArticleNotificationCriterium < ActiveRecord::Base
  belongs_to :user_article_watched
  belongs_to :article_notification_criterium
end