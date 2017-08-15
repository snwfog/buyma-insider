class UserArticleSoldExtraTariff < ActiveRecord::Base
  belongs_to :user_article_sold
  belongs_to :extra_tariff
end