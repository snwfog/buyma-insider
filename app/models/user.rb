class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :user_watched_articles, dependent:  :destroy

  has_many :user_sold_articles,    dependent:  :destroy
  
  has_one :user_auth_token,   dependent: :destroy
  
  has_one :user_metadatum,    dependent: :destroy
  

  field :id,            primary_key: true

  field :username,      type:        String,
                        required:    true,
                        max_length:  60

  field :password_hash, type:        String,
                        required:    true,
                        length:      (60..60)

  before_save :ensure_password_is_hashed
  
  def password=(password)
    unless password.blank?
      @raw_password = password
    end
  end
  
  def ensure_password_is_hashed
    if @raw_password
      self.password_hash = BCrypt::Password.new(@raw_password)
    end
  end
  
  def watched_articles
    user_watched_articles
      .eager_load(:article)
      .map(&:article)
  end
  
  def sold_articles
    user_sold_articles
      .eager_load(:article)
      .map(&:article)
  end
  
  def watch!(article, watch_criteria = [])
    if watch_criteria.empty?
      # TODO: Parameterize this
      watch_criteria << DiscountPercentArticleNotificationCriterium
                          .where(threshold_pct: 20)
                          .first_or_create!
    end
    
    create_user_watched_article!(article, watch_criteria)
  end

  def create_user_watched_article!(article, watch_criteria = [])
    user_watched_article = UserArticle
                             .create!(user:    self,
                                      article: article,
                                      _type:   :UserWatchedArticle)
    watch_criteria.each do |criterium|
      UserWatchedArticleNotificationCriterium
        .create!(user_watched_article_id:        user_watched_article.id,
                 article_notification_criterium: criterium)
    end
  end

  def destroy_user_watched_article!(article)
    self.user_watched_articles
      .where(user_id:    self.id,
             article_id: article.id)
      .first!
      .destroy
  end

  def create_user_sold_article!(article)
    UserSoldArticle.create!(user:    self,
                            article: article) and reload
  end

  def destroy_user_sold_article!(article)
    self.user_sold_articles
      .where(user_id:    self.id,
             article_id: article.id)
      .first!
      .destroy
  end
end