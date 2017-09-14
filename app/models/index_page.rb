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

class IndexPage < ActiveRecord::Base
  FRESH_IN_DAYS = 1.weeks

  has_and_belongs_to_many :articles, join_table: :index_pages_articles

  has_many :crawl_histories, dependent: :destroy
  has_many :index_pages, dependent: :destroy, inverse_of: :index_page

  belongs_to :merchant, touch: true
  belongs_to :index_page, inverse_of: :index_pages

  validates :relative_path, relative_path: true
  validates_uniqueness_of :relative_path, scope: :merchant_id
  validates_presence_of :merchant

  default_scope { eager_load(:merchant) }
  scope :root, -> { where(index_page_id: nil) }

  def full_url
    merchant.full_url << relative_path
  end

  def root?
    index_pages.empty?
  end

  def cache
    @cache ||= Cache.new(self)
  end

  def extract_nodes!
    merchant.extract_nodes!(cache.web_document)
  end

  def extract_index_pages!
    unless root?
      raise 'Only root index page extract is currently supported'
    end

    unless cache.exists?
      raise 'Index page cache does not exists'
    end

    merchant.extract_index_pages!(self)
  end

  class Cache
    delegate :relative_path, :merchant, to: :index_page
    attr_accessor :index_page

    def initialize(index_page)
      @index_page = index_page
    end

    def filename
      relative_path.tr('\\/:*?"<>|.', ?_)
    end

    def mtime
      File.mtime(path) rescue nil
    end

    def size_in_kb
      (File.size?(path) or 0) / 1000.0
    end

    def exists?
      File.exists?(path)
    end

    def fresh?
      exists? && File::mtime(path) >= FRESH_IN_DAYS.ago
    end

    def path
      File.expand_path('%<merchant_cache_dir>s/%<index_cache_filename>s' % {
        merchant_cache_dir:   merchant.html_cache_dir_create_if_not_exists!,
        index_cache_filename: filename
      })
    end

    def web_document
      File.open(path, 'rb') do |file|
        is_gzipped = file.read(2).unpack('s>') == [0x1f8b]
        file.rewind
        is_gzipped ? Zlib::GzipReader.new(file).read : file.read
      end
    end

    def nokogiri_document
      Nokogiri::HTML(web_document)
    end
  end

  def to_s
    full_url
  end
end
