require 'nobrainer'
require 'active_support/core_ext/module/delegation'

class Merchant
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  delegate :base_url, :pager_css, :item_css, :index_pages,
           to: :merchant_metadatum
  
  has_one :merchant_metadatum
   
  has_many :crawl_histories, scope: -> { order_by(created_at: :desc) }

  has_many :crawl_sessions, scope: -> { order_by(created_at: :desc) }

  has_many :articles
  
  after_initialize do
    extend("Merchants::#{name.capitalize}".safe_constantize)
  end
  
  class_attribute :indexer
  
  alias_method :code,       :id
  alias_method :metadatum,  :merchant_metadatum
  alias_method :metadatum=, :merchant_metadatum=
  alias_method :meta,       :merchant_metadatum
  alias_method :meta=,      :merchant_metadatum=
  
  field :id,   primary_key: true, required: true, format: /[a-z]{3}/
  field :name, type: String, required: true
  
  def indices
    @indices ||= index_pages.map do |path|
      indexer.new(path, merchant_metadatum)
    end
  end
end