# == Schema Information
#
# Table name: user_article_solds
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  article_id       :integer          not null
#  exchange_rate_id :integer          not null
#  price_history_id :integer          not null
#  buyer_id         :integer
#  price_sold       :decimal(18, 5)
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserArticleSold < ActiveRecord::Base
  has_and_belongs_to_many :extra_tariffs, join_table: :user_article_solds_extra_tariffs
  has_and_belongs_to_many :shipping_services, join_table: :user_article_solds_shipping_services

  has_many :user_article_sold_statuses

  belongs_to :user
  belongs_to :article
  belongs_to :price_history
  belongs_to :exchange_rate
  belongs_to :buyer

  alias_attribute :statuses, :user_article_sold_statuses

  after_create :create_default_status, unless: :status

  def status=(status)
    @status = statuses.build(status: status)
  end

  def status
    @status ||= statuses.order(created_at: :desc).take
  end

  private
  def create_default_status
    statuses.build.confirmed!
  end
end
