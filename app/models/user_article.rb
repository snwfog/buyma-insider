class UserArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user, index:    true,
                    required: true

  belongs_to :article, index:    true,
                       unique:   true,
                       required: true
  
  index :ix_user_id_article_id, [:user_id, :article_id]
end

class UserWatchedArticle < UserArticle
  has_many :user_watched_article_article_notification_criterium
end

class UserSoldArticle < UserArticle
  belongs_to :exchange_rate, index:    true,
                             required: true
end