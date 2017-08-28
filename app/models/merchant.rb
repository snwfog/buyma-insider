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

  delegate :domain,
           :pager_css,
           :item_css,
           :ssl?,
           to: :merchant_metadatum

  alias_attribute :metadatum, :merchant_metadatum
  alias_attribute :meta, :merchant_metadatum

  def html_cache_dir_create_if_not_exists!
    @html_cache_dir ||= "#{BuymaInsider.root}/tmp/cache/crawl/#{code}"

    unless File::directory?(@html_cache_dir)
      FileUtils::mkdir_p(@html_cache_dir)
    end
    @html_cache_dir
  end
end
