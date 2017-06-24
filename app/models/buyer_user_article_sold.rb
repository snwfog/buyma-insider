#
class BuyerUserArticleSold
  include NoBrainer::Document
  
  belongs_to :buyer,             index: true
  belongs_to :user_article_sold, index: true
  
  index :ix_buyer_user_article_sold_buyer_user_article_sold, [:buyer_id, :user_article_sold_id]
  
  field :buyer_id, unique: { scope: [:user_article_sold_id] }
end
