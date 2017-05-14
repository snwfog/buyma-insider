class UserArticleWatched
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  belongs_to :user,    index:    true,
                       required: true
  belongs_to :article, index:    true,
                       required: true

  has_many   :user_article_watched_notification_criteria, dependent: :destroy
  has_many   :article_notification_criteria,              through: :user_article_watched_notification_criteria

  field :user_id,      unique: { scope: [:article_id] }
  field :article_id,   unique: { scope: [:user_id] }
  
  index :ix_user_article_watched_user_id_article_id, [:user_id, :article_id]
  
  # validates_presence_of :user_article_watched_notification_criteria
  
  alias_method :criteria, :article_notification_criteria

  def all_criteria_apply?
    article_notification_criteria.all? do |criterium|
      criterium.applicable?(article)
    end
  end

  def article_notification_criterium_ids=(article_notification_criterium_ids)
    user_article_watched_notification_criteria.destroy_all
    ArticleNotificationCriterium
      .where(:id.in => article_notification_criterium_ids)
      .each do |article_notification_criterium|
      UserArticleWatchedNotificationCriterium
        .create!(user_article_watched:           self,
                 article_notification_criterium: article_notification_criterium)
    end
  end
end