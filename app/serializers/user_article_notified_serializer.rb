# == Schema Information
#
# Table name: user_article_notifieds
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  article_id :integer          not null
#  read_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserArticleNotifiedSerializer < ActiveModel::Serializer
  cache key: :user_article_notified, expires_in: 1.day

  belongs_to :article do
    include_data(true)
    # link :related, proc { "/articles/#{object.article_id}" }
  end

  belongs_to :article_notification_criteria do
    include_data(true)
    # link :related, proc {
    #   "/user_article_notifieds/#{object.id}/article_notification_criteria" }
  end

  attributes :id,
             :read_at,
             :updated_at,
             :created_at
end
