class UserArticle
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user, index:    true,
                    required: true

  belongs_to :article, index:    true,
                       unique:   true,
                       required: true
  
  index :ix_user_id_article_id, [:user_id, :article_id]
  
  def initialize(*args, &block)
    if self.class == UserArticle
      raise 'Base class `UserArticle` is not allowed to be instantiated'
    else
      super
    end
  end
end

class UserWatchedArticle < UserArticle
  has_many :watched_criteria, foreign_key: :user_watched_article_id,
                              class_name:  UserWatchedArticleNotificationCriterium,
                              dependent:   :destroy
  
  validates_presence_of :watched_criteria
end

class UserSoldArticle < UserArticle
  belongs_to :exchange_rate, index:    true,
                             required: true
end