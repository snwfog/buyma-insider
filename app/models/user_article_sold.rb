class UserArticleSold < ActiveRecord::Base
  has_and_belongs_to_many :extra_tariffs, join_table: :user_article_solds_extra_tariffs
  has_and_belongs_to_many :shipping_services, join_table: :user_article_solds_shipping_services
  
  has_one :buyer, through: :user_article_sold_buyers

  belongs_to :user
  belongs_to :article
  belongs_to :price_history
  belongs_to :exchange_rate
end