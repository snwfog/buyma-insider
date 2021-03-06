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

class UserArticleSoldSerializer < ActiveModel::Serializer
  cache key: :user_article_sold, expires_in: 1.day

  has_many :shipping_services do
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/user_article_solds/#{object.id}/shipping_services" }
    include_data true
  end

  has_many :extra_tariffs do
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/user_article_solds/#{object.id}/extra_tariffs" }
    include_data true
  end

  has_one :buyer do
    include_data true
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/buyer/#{object.buyer.id}" }
  end

  belongs_to :user do
    include_data true
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/users/#{object.user_id}" }
  end

  belongs_to :article do
    # IMPT:
    # Having include_data and link cause
    # Ember to rerender, and it seems to confuse ember
    include_data true
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/articles/#{object.article_id}" }
  end

  belongs_to :exchange_rate do
    include_data true
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/exchange_rates/#{object.exchange_rate_id}" }
  end

  attributes :status,
             :price,
             :price_sold,
             :notes,
             :confirmed_at,
             :shipped_at,
             :cancelled_at,
             :received_at,
             :returned_at,
             :created_at,
             :updated_at

  def price
    object.article.price
  end

  def status
    object.status.status
  end

  def confirmed_at
    object.statuses.where(status: :confirmed).take.try(:created_at)
  end

  def shipped_at
    object.statuses.where(status: :shipped).take.try(:created_at)
  end

  def cancelled_at
    object.statuses.where(status: :cancelled).take.try(:created_at)
  end

  def received_at
    object.statuses.where(status: :received).take.try(:created_at)
  end

  def returned_at
    object.statuses.where(status: :returned).take.try(:created_at)
  end
end
