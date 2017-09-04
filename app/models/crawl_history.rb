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
#  response_headers      :hstore
#  response_status       :integer
#  finished_at           :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class CrawlHistory < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :crawl_histories_articles

  belongs_to :index_page, touch: true

  enum status: [:scheduled, :inprogress, :aborted, :completed]
  enum response_status: Rack::Utils::SYMBOL_TO_STATUS_CODE

  validates_presence_of :status
  validates_presence_of :description

  validates_uniqueness_of :status, scope: [:index_page_id], conditions: -> { where(status: [0, 1]) }
  # default_scope { order(finished_at: :desc) }

  alias_attribute :started_at, :created_at

  def article_count
    articles.count
  end

  def etag
    response_headers.try(:[], :etag)
  end

  def weak?
    etag.try(:start_with?, ?w)
  end

  def last_modified
    response_headers.try(:[], :last_modified)
  end

  def content_encoding
    response_headers.try(:[], :content_encoding)
  end

  def use_web_cache?
    response_status == :not_modified
  end

  def elapsed_time_in_s
    if finished_at && created_at
      finished_at - created_at
    else
      Float::NaN
    end
  end
end
