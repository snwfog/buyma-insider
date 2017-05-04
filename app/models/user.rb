class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  has_many :user_article_watcheds, dependent: :destroy

  has_many :user_article_solds,    dependent: :destroy
  
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
  
  def article_watcheds
    user_article_watcheds
      .eager_load(:article)
      .map(&:article)
  end
  
  def article_solds
    user_article_solds
      .eager_load(:article)
      .map(&:article)
  end

  def watch!(article, watch_criterium)
    create_user_article_watched!(article, watch_criterium)
  end

  def create_user_article_watched!(article, watch_criterium)
    UserArticleWatched.create!(user:    self,
                               article: article).tap do |ua_watched|
      UserArticleWatchedNotificationCriterium
        .create!(user_article_watched:           ua_watched,
                 article_notification_criterium: watch_criterium)
    end
  end

  def destroy_user_article_watched!(article)
    self.user_article_watcheds
      .where(user:    self,
             article: article)
      .each(&:destroy)
  end

  def create_user_article_sold!(article)
    UserArticleSold.create!(user:    self,
                            article: article) and reload
  end
  
  def sold!(user_article_sold_json)
    UserArticleSold.create!(user_article_sold_json)
  end

  def destroy_user_article_sold!(article)
    self.user_article_solds
      .where(user:    self,
             article: article)
      .each(&:destroy)
  end
end