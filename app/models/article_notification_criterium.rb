# Percentage discount or raise at point watcher
# will be notified, default to Float::MIN (any fluctuation)
class ArticleNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  has_many :user_watched_article_article_notification_criterium

  field :id,          primary_key: true,
                      required:    true
  
  def notify?
    apply_criterium
  end
  
  def apply_criterium
    raise NotImplemented
  end
end

class DiscountThresholdArticleNotificationCriterium < ArticleNotificationCriterium
  field :threshold_pct, type:     Integer,
                        required: true,
                        default:  20,
                        in:       (0..100)
end