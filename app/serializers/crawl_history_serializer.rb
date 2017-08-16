# == Schema Information
#
# Table name: crawl_histories
#
#  id                    :integer          not null, primary key
#  index_page_id         :integer          not null
#  status                :integer          not null
#  description           :text             not null
#  article_created_count :integer          default(0)
#  article_updated_count :integer          default(0)
#  article_count         :integer          default(0)
#  article_invalid_count :integer          default(0)
#  traffic_size_in_kb    :float            default(0.0)
#  response_headers      :text             not null
#  response_status       :integer          not null
#  finished_at           :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class CrawlHistorySerializer < ActiveModel::Serializer
  # cache key: :crawl_history

  attributes :id,
             :status,
             # :link,
             :description,
             :created_articles_count,
             :updated_articles_count,
             :items_count,
             :invalid_items_count,
             :traffic_size_kb,
             :response_headers,
             :response_code,
             :finished_at,
             :created_at,
             :updated_at

  def created_articles_count
    object.article_created_count
  end

  def updated_articles_count
    object.article_updated_count
  end

  def article_count
    object.article_count
  end

  def article_invalid_count
    object.article_invalid_count
  end

  def traffic_size_kb
    object.traffic_size_in_kb
  end

  def response_code
    object.response_status
  end
end
