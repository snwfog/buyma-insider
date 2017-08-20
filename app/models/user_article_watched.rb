# == Schema Information
#
# Table name: user_article_watcheds
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  article_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserArticleWatched < ActiveRecord::Base
  has_and_belongs_to_many :article_notification_criteria, join_table: :user_article_watcheds_article_notification_criteria

  belongs_to :user
  belongs_to :article

  alias_attribute :criteria, :article_notification_criteria

  def all_criteria_apply?
    article_notification_criteria.all? do |criterium|
      criterium.applicable?(article)
    end
  end

  # def article_notification_criterium_ids=(article_notification_criterium_ids)
  #
  #   raise 'TODO IMPLEMENT'
  #   # article_notification_criteria.destroy_all
  #   # ArticleNotificationCriterium
  #   #   .where(:id.in => article_notification_criterium_ids)
  #   #   .each do |article_notification_criterium|
  #   #   UserArticleWatchedNotificationCriterium
  #   #     .create!(user_article_watched:           self,
  #   #              article_notification_criterium: article_notification_criterium)
  #   # end
  # end
end
