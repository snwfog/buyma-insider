class UserArticleNotified
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,    index:    true,
                       required: true

  belongs_to :article, index:    true,
                       required: true

  # field :_type,        type:     String # Eager create _type for polymorphic model
  field :user_id,      unique:   { scope: [:article_id, :notified_at] }
  field :article_id,   unique:   { scope: [:user_id,    :notified_at] }

  field :notified_at,  type:     Date,
                       index:    true,
                       required: true,
                       unique:   { scope: [:user_id, :article_id] }

  index :ix_user_article_notified_user_id_article_id, [:user_id, :article_id]
end