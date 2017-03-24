# Percentage discount or raise at point watcher
# will be notified, default to Float::MIN (any fluctuation)
class ArticleNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  has_many :user_watched_article_article_notification_criterium

  field :id,          primary_key: true,
                      required:    true

  def initialize(*args, &block)
    if self.class == ArticleNotificationCriterium
      raise 'Base class `ArticleNotificationCriterium` is not allowed to be instantiated'
    else
      super
    end
  end
  
  def notify?(article)
    apply_criterium(article)
  end
  
  def apply_criterium(article)
    raise NotImplemented
  end
end

class DiscountPercentArticleNotificationCriterium < ArticleNotificationCriterium
  field :threshold_pct, type:     Integer,
                        required: true,
                        default:  20,
                        in:       (0..100)

  def apply_criterium(article)
    if article.on_sale?
      prev, current = article.price_history.history.last(2)
      ((prev[:price] - current[:price]) / prev[:price].to_f) * 100 >= threshold_pct
    else
      false
    end
  end
end