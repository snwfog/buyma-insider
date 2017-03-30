class UserArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user,    index:    true,
                       required: true

  belongs_to :article, index:    true,
                       required: true

  field :_type,        type: String # Eager create _type for polymorphic model
  field :user_id,      unique: { scope: [:article_id, :_type] }
  field :article_id,   unique: { scope: [:user_id,    :_type] }
  
  index :ix_user_id_article_id__type, [:user_id, :article_id, :_type]
end

class UserWatchedArticle < UserArticle
  has_many :user_watched_article_notification_criteria, foreign_key: :user_watched_article_id,
                                                        dependent:   :destroy
  
  has_many :article_notification_criteria, through: :user_watched_article_notification_criteria
  # validate :watched_criteria, :ensure_presence_of_watched_criteria
  #
  # def ensure_presence_of_watched_criteria
  #   unless UserWatchedArticleNotificationCriterium
  #            .where(user_watched_article_id: id)
  #            .any?
  #     errors.add(:watched_criteria, 'Watched criteria can\'t be empty')
  #   end
  # end
  
  def should_notify?
    article_notification_criteria.all? do |criterium|
      criterium.applicable?(article)
    end
  end
  
  def notify!(date)
    UserNotifiedArticle.create!(user:        user,
                                article:     article,
                                notified_at: date)
  end
end

class UserSoldArticle < UserArticle
  belongs_to :exchange_rate, index:    true,
                             required: true
end

class UserNotifiedArticle < UserArticle
  field :notified_at, type:     Date,
                      index:    true,
                      required: true,
                      default:  -> { Time.now.utc.to_date }

  validate :notified_at, :ensure_unique_user_article_notified_at
  
  around_save :ensure_unique_user_article_notified_at

  def ensure_unique_user_article_notified_at
    NoBrainer::Lock.new("#{user.id}:#{article.id}:#{notified_at}").synchronize do
      if UserNotifiedArticle.where(user_id:     user.id,
                                   article_id:  article.id,
                                   notified_at: notified_at).any?
        errors.add(:base, 'User article notified at must be compositely unique')
      else
        yield if block_given?
      end
    end
  end
end