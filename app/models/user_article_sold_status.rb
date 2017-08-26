# == Schema Information
#
# Table name: user_article_sold_statuses
#
#  id                   :integer          not null, primary key
#  user_article_sold_id :integer          not null
#  status               :integer          default("confirmed"), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class UserArticleSoldStatus < ActiveRecord::Base
  belongs_to :user_article_sold, touch: true

  enum status: [:confirmed, :shipped, :received, :cancelled, :returned]

  validates_presence_of :status
  validates_uniqueness_of :status, scope: [:user_article_sold_id]
end
