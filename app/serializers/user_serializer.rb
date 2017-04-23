class UserSerializer < ActiveModel::Serializer
  # user_watched_articles
  has_many :watched_articles do
    link :related, proc { "/users/#{object.id}/watched_articles" }
  end

  # user_sold_articles
  has_many :sold_articles do
    link :related, proc { "/users/#{object.id}/sold_articles"}
  end
  
  attributes :username,
             :created_at,
             :updated_at
end