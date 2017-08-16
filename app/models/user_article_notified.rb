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

class UserArticleNotified < ActiveRecord::Base
  has_and_belongs_to_many :article_notification_criteria, join_table: :user_article_notifieds_article_notification_criteria

  belongs_to :user
  belongs_to :article

  def read!
    self.read_at = Time.now # default is utc
  end

  def read?
    !read_at.nil?
  end
end
