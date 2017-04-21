class UserWatchedArticleSerializer < ActiveModel::Serializer
  belongs_to :user do
    link :related, proc { "/users/#{object.user_id}" }
    include_data true
  end
  
  belongs_to :article do
    link :related, proc { "/articles/#{object.article_id}" }
    include_data true
  end
  
  attributes :created_at,
             :updated_at
end