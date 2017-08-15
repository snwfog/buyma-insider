class UserArticleNotifiedArticleNotificationCriterium < ActiveRecord::Base
  belongs_to :user_article_notified
  belongs_to :article_notification_criterium
end