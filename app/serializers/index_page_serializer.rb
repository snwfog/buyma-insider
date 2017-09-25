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
#  web_cache_at  :datetime
#

class IndexPageSerializer < ActiveModel::Serializer
  HEALTH_GREEN  = :green
  HEALTH_ORANGE = :orange
  HEALTH_RED    = :red

  cache key: :index_page,
        # except:     [:last_synced_at],
        expires_in: 1.day

  belongs_to :index_page do
    include_data(true)
  end

  has_many :index_pages, if: :root? do
    include_data(true)
  end

  attributes :id,
             :full_url,
             :relative_path,
             :last_synced_at,
             :cache_mtime,
             :health

  def root?
    object.root?
  end

  def last_synced_at
    object.crawl_histories.completed.last.try(:created_at)
  end

  def cache_mtime
    object.cache.mtime
  end

  def health
    last_crawl_histories           = object.crawl_histories.last(3)
    articles_count_total,
      articles_invalid_count_total =
      last_crawl_histories.inject([0.0, 0.0]) do |(valid_article_cnt, invalid_article_cnt), crawl_history|
        [valid_article_cnt + crawl_history.article_count,
         invalid_article_cnt + crawl_history.article_invalid_count]
      end

    if last_crawl_histories.all?(&:completed?) && articles_invalid_count_total == 0
      HEALTH_GREEN
    elsif last_crawl_histories.any?(&:aborted?) || (articles_invalid_count_total / (articles_count_total + articles_invalid_count_total)) > 0.5
      HEALTH_RED
    else
      HEALTH_ORANGE
    end
  end
end
