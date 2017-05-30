class UserArticleWatchedSerializer < ActiveModel::Serializer
  belongs_to :user do
    # include_data true
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/users/#{object.user_id}" }
  end
  
  belongs_to :article do
    include_data(true)
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/articles/#{object.article_id}" }
  end
  
  has_many :article_notification_criteria do
    # include_data(true) # This might screw up others because it will render data: [] if there is no data
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/user_article_watcheds/#{object.id}/article_notification_criteria" }
  end
  
  attributes :created_at,
             :updated_at
end