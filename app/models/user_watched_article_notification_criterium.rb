class UserWatchedArticleNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_watched_article,           index:    true,
                                              required: true
  
  belongs_to :article_notification_criterium, index:    true,
                                              required: true

  index :ix_user_watched_article_id_article_notification_criterium_id,
        [:user_watched_article_id, :article_notification_criterium_id]
end