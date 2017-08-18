# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(100)      not null
#  email_address :string(1000)     not null
#  password_hash :string(500)      not null
#  last_seen_at  :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class User < ActiveRecord::Base
  has_many :user_article_solds, dependent: :destroy
  has_many :article_solds, -> { eager_load(:article) }, through: :user_article_solds
  has_many :user_article_watcheds, dependent: :destroy
  has_many :article_watcheds, -> { eager_load(:article) }, through: :user_article_watcheds
  has_many :user_article_notifieds, dependent: :destroy
  has_many :article_notifieds, -> { eager_load(:article) }, through: :user_article_notifieds
  has_many :user_auth_tokens, dependent: :destroy
  has_one :user_metadatum, dependent: :destroy

  validates_length_of :username, within: (1..60)
  validates_length_of :password_hash, is: 60

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

  def watch_article!(article, watch_criterium)
    create_user_article_watched!(user:    self,
                                 article: article).tap do |ua_watched|
      ua_watched
        .article_notification_criteria
        .create!(article_notification_criterium: watch_criterium)
    end
  end

  def unwatch_article!(article)
    user_article_watcheds.where(article: article).destroy!
  end

  def sold_article!(user_article_sold_json)
    create_user_article_sold!(user_article_sold_json)
  end

  def unsold_article!(article)
    user_article_solds.where(article: article).destroy!
  end
end
