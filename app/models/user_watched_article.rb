class UserWatchedArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,    index:    true,
                       required: true

  belongs_to :article, index:    true,
                       required: true

  has_many :user_watched_article_notification_criteria, dependent:   :destroy

  has_many :article_notification_criteria, through: :user_watched_article_notification_criteria

  field :user_id,      unique:   { scope: [:article_id] }
  field :article_id,   unique:   { scope: [:user_id] }
  
  index :ix_user_watched_article_user_id_article_id, [:user_id, :article_id]

  def all_criteria_applies?
    article_notification_criteria.all? do |criterium|
      criterium.applicable?(article)
    end
  end

  def notify!(notified_at)
    create_user_notified_article!(notified_at)
  end

  def create_user_notified_article!(notified_at)
    UserNotifiedArticle
      .create!(user:        user,
               article:     article,
               notified_at: notified_at)
  rescue NoBrainer::Error::DocumentInvalid
    # TODO: Log this
    raise
  end
end