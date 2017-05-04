class UserArticleWatchedSerializer < ActiveModel::Serializer
  belongs_to :user do
    link :related, proc { "/users/#{object.user_id}" }
    # include_data true
  end
  
  belongs_to :article do
    link :related, proc { "/articles/#{object.article_id}" }
    include_data(true)
  end
  
  has_many :article_notification_criteria do
    link :related, proc {
      "/user_article_watcheds/#{object.id}/article_notification_criteria" }
    # include_data(true) # This might screw up others because it will render data: [] if there is no data
  end
  
  attributes :created_at,
             :updated_at
end