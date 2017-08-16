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

class UserSerializer < ActiveModel::Serializer
  has_many :article_watcheds do
    link :related, 'article_watcheds'
  end
  
  has_many :article_solds do
    link :related, 'article_solds'
  end
  
  has_many :article_notifieds do
    link :related, 'article_notifieds'
  end
  
  attributes :username,
             :created_at,
             :updated_at
end
