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
  # Percentage discount or raise at point watcher
  # will be notified, default to Float::MIN (any fluctuation)
  field :interest_threshold_pc, type:    Float,
                                in:      (1..100),
                                default: Float::MIN
end

class UserSoldArticle < UserArticle
  belongs_to :exchange_rate, index:    true,
                             required: true
end
