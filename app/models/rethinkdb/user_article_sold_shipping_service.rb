class UserArticleSoldShippingService
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  belongs_to :user_article_sold, index:    true,
                                 required: true
  belongs_to :shipping_service,  index:    true,
                                 required: true
  
  field :shipping_service_id,    unique:   { scope: [:user_article_sold_id] }
  
  index :ix_user_article_sold_shipping_service_user_user_article_sold_id_shipping_service_id,
        [:user_article_sold_id, :shipping_service_id]
end