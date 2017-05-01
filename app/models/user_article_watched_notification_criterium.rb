class UserArticleWatchedNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_article_watched,           index:    true,
                                              required: true
  belongs_to :article_notification_criterium, index:    true,
                                              required: true

  index :ix_user_article_watched_notification_criterium_user_article_watched_id_article_notification_criterium_id,
        [:user_article_watched_id, :article_notification_criterium_id]
  
  delegate :applicable?, to: :article_notification_criterium
end