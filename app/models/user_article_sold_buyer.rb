#
class UserArticleSoldBuyer
  include NoBrainer::Document

  belongs_to :user_article_sold, index: true
  belongs_to :buyer,             index: true

  index :ix_buyer_user_article_sold_user_article_sold_id_buyer_id,
        [:buyer_id, :user_article_sold_id]

  field :buyer_id, unique: { scope: [:user_article_sold_id] }
end
