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
  CACHE_FRESH_IN_DAYS = 1.weeks

  has_and_belongs_to_many :articles, join_table: :index_pages_articles

  has_many :crawl_histories, dependent: :destroy
  has_many :index_pages, dependent: :destroy, inverse_of: :index_page

  belongs_to :merchant, touch: true
  belongs_to :index_page, inverse_of: :index_pages

  validates_uniqueness_of :relative_path, scope: :merchant_id
  validates_presence_of :merchant

  default_scope { eager_load(:merchant) }
  scope :root, -> { where(index_page_id: nil) }

  def full_url
    merchant.full_url << relative_path
  end

  def cache_filename
    relative_path.tr('\\/:*?"<>|.', ?_)
  end

  def cache_html_path
    File.expand_path('%<merchant_cache_dir>s/%<index_cache_filename>s' % {
      merchant_cache_dir:   merchant.html_cache_dir_create_if_not_exists!,
      index_cache_filename: cache_filename
    })
  end

  def cache_mtime
    File.mtime(cache_html_path) rescue nil
  end

  def cache_html_document
    RestClient::Request.decode(cache_html_content_encoding,
                               cache_html_content)
  end

  def has_web_cache?
    File.exists?(cache_html_path)
  end

  def is_cache_fresh?
    has_web_cache? && File::mtime(cache_html_path) >= CACHE_FRESH_IN_DAYS.ago
  end

  def to_s
    full_url
  end

  private

  def cache_html_content
    @cache_html_content_encoded ||= File.open(cache_html_path, 'rb', &:read)
  end

  def cache_html_content_encoding
    crawl_histories
      .order(finished_at: :desc)
      .completed
      .take
      .try(:content_encoding) || 'gzip'.freeze
  end
end
