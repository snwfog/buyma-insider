# Percentage discount or raise at point watcher
# will be notified, default to Float::MIN (any fluctuation)
class ArticleNotificationCriterium
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  
  has_many :user_article_watched_article_notification_criterium

  field :id,          primary_key: true,
                      required:    true
  
  around_save :fetch_from_cache

  # def initialize(*args, &block)
  #   if self.class == ArticleNotificationCriterium
  #     raise 'Base class `ArticleNotificationCriterium` is not allowed to be instantiated'
  #   else
  #     super
  #   end
  # end
  def _cache
    @@_cache ||= LruRedux::Cache.new(1_000)
  end
  
  def exists_in_cache
    !!_cache.get(_cache_key)
  end

  def _cache_key
    case self
    when DiscountPercentArticleNotificationCriterium
      'discount_%i_pct' % self.threshold_pct
    else
      raise 'Unknown article notification criterium'
    end
  end

  def fetch_from_cache
    _cache.getset(_cache_key) { yield and self }
  end


  def applicable?(article)
    apply_criterium(article)
  end
  
  def apply_criterium(article)
    raise NotImplemented
  end
end

class DiscountPercentArticleNotificationCriterium < ArticleNotificationCriterium
  field :threshold_pct, type:     Integer,
                        required: true,
                        unique:   true,
                        default:  20,
                        in:       (0...100)

  def apply_criterium(article)
    if article.on_sale?
      prev, current = article.price_history.history.last(2)
      (((prev[:price] - current[:price]) / prev[:price].to_f) * 100).round >= threshold_pct
    else
      false
    end
  end
end