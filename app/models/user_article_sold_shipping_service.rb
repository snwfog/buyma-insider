class UserArticleSoldShippingService < ActiveRecord::Base
  belongs_to :user_article_sold
  belongs_to :shipping_service
end