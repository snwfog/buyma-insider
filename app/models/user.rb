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
  has_many :user_article_watcheds, dependent: :destroy
  has_many :user_article_notifieds, dependent: :destroy
  has_many :user_auth_tokens, dependent: :destroy
  has_one :user_metadatum, dependent: :destroy
end
