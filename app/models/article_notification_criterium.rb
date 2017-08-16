# == Schema Information
#
# Table name: article_notification_criteria
#
#  id         :integer          not null, primary key
#  name       :string(500)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArticleNotificationCriterium < ActiveRecord::Base
  has_and_belongs_to_many :user_article_watcheds, join_table: :user_article_watcheds_article_notification_criteria
  has_and_belongs_to_many :user_article_notifieds, join_table: :user_article_notifieds_article_notification_criteria

  def applicable?(article)
    apply_criterium(article)
  end

  def apply_criterium(article)
    raise NotImplemented
  end
end

# class DiscountPercentArticleNotificationCriterium < ArticleNotificationCriterium
#   field :threshold_pct, type:     Integer,
#         required: true,
#         unique:   true,
#         index:    true,
#         default:  20,
#         in:       (0...100)
#
#   def apply_criterium(article)
#     if article.on_sale?
#       article.price_history.discounted_pct >= threshold_pct
#     else
#       false
#     end
#   end
# end
