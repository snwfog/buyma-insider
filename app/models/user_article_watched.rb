class UserArticleWatched < ActiveRecord::Base
  has_and_belongs_to_many :article_notification_criteria, join_table: :user_article_watcheds_article_notification_criteria

  belongs_to :user
  belongs_to :article
end