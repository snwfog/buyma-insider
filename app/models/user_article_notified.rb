class UserArticleNotified < ActiveRecord::Base
  has_and_belongs_to_many :article_notification_criteria, join_table: :user_article_notifieds_article_notification_criteria

  belongs_to :user
  belongs_to :article
end