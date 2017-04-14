class UserSoldArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,          index:    true,
                             required: true

  belongs_to :article,       index:    true,
                             required: true

  belongs_to :exchange_rate, index:    true,
                             required: true

  field :user_id,      unique:   { scope: [:article_id] }
  field :article_id,   unique:   { scope: [:user_id] }
  
  index :ix_user_sold_article_user_id_article_id, [:user_id, :article_id]
end