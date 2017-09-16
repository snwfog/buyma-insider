# == Schema Information
#
# Table name: merchants
#
#  id         :integer          not null, primary key
#  code       :string(3)        not null
#  name       :string(500)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Merchant < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  has_many :index_pages, dependent: :destroy

  has_one :merchant_metadatum, dependent: :destroy

  validates_format_of :code, with: /[a-z]{3}/

  default_scope { includes(:merchant_metadatum) }

  after_find do
    extend "Merchants::#{name.classify}".safe_constantize
  end

  class_attribute :indexer

  delegate :domain, :scheme, :full_url,
           :pager_css, :item_css, :ssl?, to: :merchant_metadatum

  alias_attribute :metadatum, :merchant_metadatum
  alias_attribute :meta, :merchant_metadatum

  def html_cache_dir_create_if_not_exists!
    @html_cache_dir ||= "#{BuymaInsider.root}/tmp/web_cache/#{code}"

    unless File::directory?(@html_cache_dir)
      FileUtils::mkdir_p(@html_cache_dir)
    end
    @html_cache_dir
  end

  # @override Cookies for index page fetch
  def cookies
    {}
  end

  # @override Query strings for index page fetch
  def query_strings
    {}
  end

  # @override Headers for index page fetch
  def headers
    @standard_headers ||= begin
      spoof_ip_address = GeoIpLocation.random_canadian.begin_ip_address

      { x_forwarded_for:  spoof_ip_address,
        x_forwarded_host: spoof_ip_address,
        user_agent:       BuymaInsider::SPOOF_USER_AGENT,
        accept_encoding:  'gzip',
        cache_control:    'no-cache',
        pragma:           'no-cache' }
    end
  end

  def extract_nodes!(web_document)
    Nokogiri::HTML(web_document).css(item_css)
  end

  def extract_index_pages!(root_index_page)
    root_index_page.cache.nokogiri_document.at_css(pager_css)
  end

  def extract_attrs!(node)
    raise 'Not implemented'
  end
end
