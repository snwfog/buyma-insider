class UserSoldArticleSerializer < ActiveModel::Serializer
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
  
  attributes :created_at,
             :updated_at
end