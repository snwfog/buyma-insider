class UserArticleSoldSerializer < ActiveModel::Serializer
  belongs_to :user do
    # include_data true
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/users/#{object.user_id}" }
  end
  
  belongs_to :article do
    include_data true
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/articles/#{object.article_id}" }
  end
  
  belongs_to :exchange_rate do
    # link :related, proc {
    #   "/#{BuymaInsider::API_VERSION}/exchange_rates/#{object.exchange_rate_id}" }
    include_data(true)
  end
  
  has_many :shipping_services do
    link :related, proc {
      "/#{BuymaInsider::API_VERSION}/user_article_solds/#{object.id}/shipping_services"}
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