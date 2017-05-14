class ArticleSerializer < ActiveModel::Serializer
  cache key: :article, expires_in: 24.hours
  
  has_one :price_history do
    # If this block was present,
    # the value of this block will ultimately be
    # the association, leaving it commented
    # and and include_data config is false, then
    # relationship will render as meta: {} only
    # see active_model_serializers/adapter/json_api/relationship.rb
    include_data true
  end
  
  has_many :article_relateds do
    link :related, proc { "/articles/#{object.id}/article_relateds"}
  end
  
  
  attributes :id,
             :name,
             :description,
             :price,
             :link,
             # :price_summary,
             :synced_at,
             :created_at,
             :updated_at

  def synced_at
    object
      .crawl_history_articles
      .first
      &.created_at
  end
  
  class PriceHistorySerializer < ActiveModel::Serializer
    cache key: :price_history
    
    attributes :currency,
               :history,
               :max_price,
               :min_price
  end
  
  # def price_summary
  #   histories = object.price_history.history
  #   stats     = Hash.new
  #   unless histories.empty?
  #     min, max    = histories.minmax
  #     stats[:max] = { seen_at: max.first, price: max.last.to_f }
  #     stats[:min] = { seen_at: min.first, price: min.last.to_f }
  #     stats[:avg] = { price: histories.values.inject(0.0, :+) / histories.count }
  #   end
  #   stats
  # end

end
