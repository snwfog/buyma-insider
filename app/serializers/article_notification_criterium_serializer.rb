class ArticleNotificationCriteriumSerializer < ActiveModel::Serializer
  cache key: :article_notification_criterium, expires_in: 1.week
  
  attributes :id,
             :name
end

class DiscountPercentArticleNotificationCriteriumSerializer < ArticleNotificationCriteriumSerializer
  attributes :threshold_pct
end