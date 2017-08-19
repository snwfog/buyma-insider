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

class CrawlHistory < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :crawl_histories_articles

  belongs_to :index_page

  enum status: [:scheduled, :inprogress, :aborted, :completed]
  enum response_status: Rack::Utils::SYMBOL_TO_STATUS_CODE

  default_scope { order(finished_at: :desc) }

  alias_attribute :started_at, :created_at

  def response_headers
    headers_yaml = super
    @response_headers = headers_yaml.blank? ? nil : YAML.load(headers_yaml)
  end

  def response_headers=(headers_h)
    super YAML.dump(headers_h) unless headers_h.blank?
  end

  def etag
    response_headers && response_headers[:etag]
  end

  def weak?
    etag && etag.start_with?(?W)
  end

  def last_modified
    response_headers && response_headers[:last_modified]
  end

  def content_encoding
    response_headers && response_headers[:content_encoding]
  end

  def cache_resolve?
    response_status == :not_modified
  end
end
