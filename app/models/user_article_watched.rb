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
end
