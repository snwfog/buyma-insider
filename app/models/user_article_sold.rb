# == Schema Information
#
# Table name: user_article_solds
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  article_id       :integer          not null
#  exchange_rate_id :integer          not null
#  price_history_id :integer          not null
#  price_sold       :decimal(18, 5)
#  status           :integer          not null
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserArticleSold < ActiveRecord::Base
  has_and_belongs_to_many :extra_tariffs, join_table: :user_article_solds_extra_tariffs
  has_and_belongs_to_many :shipping_services, join_table: :user_article_solds_shipping_services

  has_one :buyer, through: :user_article_sold_buyers

  belongs_to :user
  belongs_to :article
  belongs_to :price_history
  belongs_to :exchange_rate

  enum status: [:confirmed, :shipped, :cancelled, :received, :returned]

  # TODO: Move this to another table
  # State cycle for a sold article update status and timestamp
  # (STATUS - [:confirmed]).each do |state|
  #   field :"#{state}_at", type: Time
  #   define_method("#{state}!") do
  #     super() and self.__send__("#{state}_at=", Time.now)
  #   end
  # end

  def create_buyer!(buyer_payload)
    buyer.where(buyer_payload).first_or_create!
  end
end
