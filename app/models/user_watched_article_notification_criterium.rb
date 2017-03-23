class UserWatchedArticleNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_watched_article, index:    true,
                                    required: true
  
  belongs_to :article_notification_criterium, index:    true,
                                              required: true
  
end