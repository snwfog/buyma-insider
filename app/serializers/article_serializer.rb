class ArticleSerializer < ActiveModel::Serializer
  cache key: :article
  
  has_one :price_history do
    # If this block was present,
    # the value of this block will ultimately be
    # the association, leaving it commented
    # and and include_data config is false, then
    # relationship will render as meta: {} only
    include_data true
  end
  
  attributes :id,
             :name,
             :description,
             :price,
             :link,
             # :price_summary,
             :created_at,
             :updated_at
  
  class PriceHistorySerializer < ActiveModel::Serializer
    attributes :currency,
               :history
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
