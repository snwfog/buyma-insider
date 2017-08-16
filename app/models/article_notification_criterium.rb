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
end
