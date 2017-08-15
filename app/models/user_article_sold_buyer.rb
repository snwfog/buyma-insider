class UserArticleSoldBuyer < ActiveRecord::Base
  belongs_to :user_article_sold
  belongs_to :buyer
end