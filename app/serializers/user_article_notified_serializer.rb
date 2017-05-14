class UserArticleNotifiedSerializer < ActiveModel::Serializer
  belongs_to :article do
    link :related, proc { "/articles/#{object.article_id}" }
  end
  
  belongs_to :article_notification_criteria do
    link :related, proc {
      "/user_article_notifieds/#{object.id}/article_notification_criteria" }
  end
  
  attributes :id,
             :read_at,
             :updated_at,
             :created_at
end