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
  has_many :article_solds, through: :user_article_solds, source: :article
  has_many :user_article_watcheds, dependent: :destroy
  has_many :article_watcheds, through: :user_article_watcheds, source: :article
  has_many :user_article_notifieds, dependent: :destroy
  has_many :article_notifieds, through: :user_article_notifieds, source: :article
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

  def watch_article!(article,
                     watch_criterium = DiscountPercentArticleNotificationCriterium.default_notification)
    transaction do
      ua_watched = user_article_watcheds.create!(article: article)
      ua_watched.article_notification_criteria << watch_criterium
      ua_watched
    end
  end

  def sold_article!(user_article_sold_json)
    user_article_solds.create!(user_article_sold_json)
  end
end
