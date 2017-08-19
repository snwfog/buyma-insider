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

  validates_uniqueness_of :relative_path, scope: :merchant_id
  validates_presence_of :merchant

  default_scope { eager_load(:merchant) }
  scope :root, -> { where(index_page_id: nil) }

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
    File.expand_path('%<root>s/tmp/cache/crawl/%<merchant_code>s/%<cache_filename>s' % {
      root:           BuymaInsider.root,
      merchant_code:  merchant.code,
      cache_filename: cache_filename
    })
  end

  def has_cache_html?
    File.exists?(cache_html_path)
  end

  def cache_html_document
    RestClient::Request.decode(cache_html_content_encoding,
                               cache_html_content)
  end

  def to_s
    full_url
  end

  private

  def cache_html_content
    @cache_html_content_encoded ||= File.open(cache_html_path, 'rb', &:read)
  end

  def cache_html_content_encoding
    crawl_histories.completed.first&.content_encoding || 'gzip'.freeze
  end
end
