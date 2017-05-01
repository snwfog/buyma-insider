class UserSoldArticleShippingService
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_sold_article, index:    true,
                                 required: true
  belongs_to :shipping_service,  index:    true,
                                 required: true
  
  index :ix_user_sold_article_id_shipping_service_id, [:user_sold_article_id, :shipping_service_id]
end