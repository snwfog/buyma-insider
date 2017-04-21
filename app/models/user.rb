class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :user_watched_articles, dependent: :destroy

  has_many :user_sold_articles,    dependent: :destroy
  
  has_many :user_session_tokens,   dependent: :destroy
  
  has_one :user_metadatum,    dependent: :destroy
  

  field :id,            primary_key: true

  field :username,      type:        String,
                        required:    true,
                        unique:      true,
                        max_length:  60
  
  field :email,         type:        String,
                        unique:      true,
                        required:    true,
                        max_length:  500

  field :password_hash, type:        String,
                        required:    true,
                        length:      (60..60)
  
  field :last_seen_at,  type:        Time

  before_validation :ensure_password_is_hashed
  
  def valid_password?(password)
    BCrypt::Password.new(password_hash) == password
  end
  
  def validate_password!(password)
    raise InvalidPassword unless valid_password?(password)
  end
  
  def password=(password)
    unless password.blank?
      @raw_password = password
    end
  end
  
  def ensure_password_is_hashed
    if @raw_password
      self.password_hash = BCrypt::Password.create(@raw_password.to_s)
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
      # TODO: Parameterize this in a configuration
      watch_criteria << DiscountPercentArticleNotificationCriterium
                          .where(threshold_pct: 20)
                          .first_or_create!
    end
    
    create_user_watched_article!(article, watch_criteria)
  end

  def create_user_watched_article!(article, watch_criteria = [])
    user_watched_article = UserWatchedArticle
                             .create!(user:    self,
                                      article: article)
    
    watch_criteria.each do |criterium|
      UserWatchedArticleNotificationCriterium
        .create!(user_watched_article_id:        user_watched_article.id,
                 article_notification_criterium: criterium)
    end
    
    user_watched_article
  end

  def destroy_user_watched_article!(article)
    self.user_watched_articles
      .where(user:    self,
             article: article)
      .each(&:destroy)
  end

  def create_user_sold_article!(article)
    UserSoldArticle.create!(user:    self,
                            article: article) and reload
  end

  def destroy_user_sold_article!(article)
    self.user_sold_articles
      .where(user:    self,
             article: article)
      .each(&:destroy)
  end
end