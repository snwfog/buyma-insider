class UserArticleNotifiedNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_article_notified,          index:    true,
                                              required: true
  belongs_to :article_notification_criterium, index:    true,
                                              required: true

  index :ix_user_article_notified_notification_criterium_user_article_notified_id_article_notification_criterium_id,
        [:user_article_notified_id, :article_notification_criterium_id]
  
  field :article_notification_criterium_id, unique: { scope: [:user_article_notified_id] }
end