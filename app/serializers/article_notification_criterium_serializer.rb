# == Schema Information
#
# Table name: article_notification_criteria
#
#  id         :integer          not null, primary key
#  name       :string(500)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArticleNotificationCriteriumSerializer < ActiveModel::Serializer
  cache key: :article_notification_criterium, expires_in: 1.week
  
  attributes :id,
             :name
end

class DiscountPercentArticleNotificationCriteriumSerializer < ArticleNotificationCriteriumSerializer
  attributes :threshold_pct
end
