class UserArticleSoldExtraTariff
  include NoBrainer::Document

  belongs_to :user_article_sold, index: true
  belongs_to :extra_tariff,      index: true

  index :ix_user_article_sold_extra_tariff_user_article_sold_id_extra_tariff_id,
        [:user_article_sold_id, :extra_tariff_id]
end