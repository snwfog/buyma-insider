# class UserArticleWatchedArticleNotificationCriterium < ActiveRecord::Base
#   belongs_to :user_article_watched, dependent: :destroy
#   belongs_to :article_notification_criterium, dependent: :destroy
# end