class User < ActiveRecord::Base
  has_many :user_article_solds, dependent: :destroy
  has_many :user_article_watcheds, dependent: :destroy
  has_many :user_article_notifieds, dependent: :destroy
  has_many :user_auth_tokens, dependent: :destroy
  has_one :user_metadatum, dependent: :destroy
end