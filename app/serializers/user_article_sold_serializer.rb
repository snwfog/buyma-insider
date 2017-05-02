class UserArticleSoldSerializer < ActiveModel::Serializer
  belongs_to :user do
    link :related, proc { "/users/#{object.user_id}" }
    # include_data true
  end
  
  belongs_to :article do
    link :related, proc { "/articles/#{object.article_id}" }
    include_data true
  end
  
  belongs_to :exchange_rate do
    link :related, proc { "/exchange_rates/#{object.exchange_rate_id}" }
  end
  
  has_many :shipping_services do
    link :related, proc { "/user_article_solds/#{object.id}/shipping_services"}
  end
  
  attributes :status,
             :price,
             :sold_price,
             :confirmed_at,
             :shipped_at,
             :cancelled_at,
             :received_at,
             :returned_at,
             :created_at,
             :updated_at
end