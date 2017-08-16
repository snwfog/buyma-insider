# == Schema Information
#
# Table name: index_pages
#
#  id            :integer          not null, primary key
#  merchant_id   :integer          not null
#  index_page_id :integer
#  relative_path :string(2000)     not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class IndexPageSerializer < ActiveModel::Serializer
  HEALTH_GREEN  = :green
  HEALTH_ORANGE = :orange
  HEALTH_RED    = :red

  cache key:        :index_page,
        # except:     [:last_synced_at],
        expires_in: 5.minute

  attributes :id,
             :full_url,
             :relative_path,
             :last_synced_at,
             :health
  
  def last_synced_at
    if crawl_history = object.crawl_histories.first
      crawl_history.created_at
    end
  end

  def health
    crawl_histories                                  = object.crawl_histories.limit(10)
    article_count_total, invalid_article_count_total = crawl_histories.inject([0, 0]) do |(valid_article_cnt, invalid_article_cnt), crawl_hist|
      valid_article_cnt   += crawl_hist.article_count
      invalid_article_cnt += crawl_hist.article_invalid_count
      [valid_article_cnt, invalid_article_cnt]
    end

    if not crawl_histories.any?(&:completed?) || invalid_article_count_total > article_count_total
      HEALTH_RED
    elsif crawl_histories.any?(&:aborted?) || invalid_article_count_total > 0
      HEALTH_ORANGE
    else
      HEALTH_GREEN
    end
  end
end
