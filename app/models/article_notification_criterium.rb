# == Schema Information
#
# Table name: article_notification_criteria
#
#  id            :integer          not null, primary key
#  name          :string(500)      not null
#  threshold_pct :float
#  type          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ArticleNotificationCriterium < ActiveRecord::Base
  has_and_belongs_to_many :user_article_watcheds, join_table: :user_article_watcheds_article_notification_criteria
  has_and_belongs_to_many :user_article_notifieds, join_table: :user_article_notifieds_article_notification_criteria

  def applicable?(article)
    apply_criterium(article)
  end

  def apply_criterium(article)
    raise NotImplemented
  end
end

class DiscountPercentArticleNotificationCriterium < ArticleNotificationCriterium
  scope :default_notification, -> { where(threshold_pct: 10).take }

  def apply_criterium(article)
    on_sale = false
    article.price_histories
      .order(created_at: :desc)
      .reduce(article.price) do |prev_price, current|
      curr_price = current.price
      next if prev_price == curr_price # there is no price change

      on_sale = curr_price > prev_price
      on_sale_pct = (curr_price - prev_price) / curr_price * 100.0

      break if on_sale && on_sale_pct >= threshold_pct
      curr_price
    end

    on_sale
  end
end
