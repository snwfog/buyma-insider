class UserArticleNotified
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,                           index:    true,
                                              required: true
  belongs_to :article,                        index:    true,
                                              required: true
  
  has_many :user_article_notified_notification_criteria, dependent: :destroy
  has_many :article_notification_criteria,               through: :user_article_notified_notification_criteria
  
  # field :_type,        type:     String # Eager create _type for polymorphic model
  field :user_id,                           unique: { scope: [:article_id] }
  field :article_id,                        unique: { scope: [:user_id] }
  field :read_at,                           type:   Time
  # field :notified_at,  type:     Date,
  #                      index:    true,
  #                      required: true,
  #                      unique:   { scope: [:user_id, :article_id] }
  index :ix_user_article_notified_user_id_article_id, [:user_id, :article_id]
  
  def read!
    self.read_at = Time.now
  end
  
  def read?
    !!read_at
  end
end