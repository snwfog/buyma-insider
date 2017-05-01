class UserSerializer < ActiveModel::Serializer
  has_many :article_watcheds do
    link :related, proc { "/users/#{object.id}/article_watcheds" }
  end

  has_many :article_solds do
    link :related, proc { "/users/#{object.id}/article_solds"}
  end
  
  attributes :username,
             :created_at,
             :updated_at
end