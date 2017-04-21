class UserSerializer < ActiveModel::Serializer
  has_many :watched_articles do
    link :related, proc { "/users/#{object.id}/watched_articles" }
  end
  
  attributes :username,
             :created_at,
             :updated_at
end