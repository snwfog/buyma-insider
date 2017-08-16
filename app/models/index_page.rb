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

class IndexPage < ActiveRecord::Base
  has_and_belongs_to_many :articles, join_table: :index_pages_articles

  has_many :crawl_histories, dependent: :destroy
  has_many :index_pages, dependent: :destroy

  belongs_to :merchant
  belongs_to :index_page

  def full_url
    domain = merchant.metadatum.domain
    scheme << ':' << domain << relative_path
  end

  def scheme
    merchant.metadatum.ssl? ? 'https' : 'http'
  end

  def cache_filename
    relative_path.tr('\\/:*?"<>|.', ?_)
  end

  def cache_html_path
    File.expand_path('%<app_path>s/tmp/cache/crawl/%<merchant_id>s/%<cache_filename>s' % {
      root:           BuymaInsider.root,
      merchant_id:    merchant_id,
      cache_filename: cache_filename
    })
  end

  def cache_html_content
    File.open(cache_html_path, 'rb') { |file| file.read }
  end

  def cache_html_content_encoding
    crawl_histories.completed.first&.content_encoding || 'gzip'.freeze
  end

  # Its always the latest and we assume
  # there can be only 1 of them at the cache location
  def cache_html_document
    if File.exists?(cache_html_path)
      @cache_html_document ||= RestClient::Request.decode(content_encoding, cache_html_content)
    end
  end

  def to_s
    full_url
  end
end
