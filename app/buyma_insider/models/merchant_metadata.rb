require 'nobrainer'

class MerchantMetadata
  include NoBrainer::Document
  
  has_many :crawl_history, foreign_key: :merchant_id
  has_many :article,       foreign_key: :merchant_id

  field :id,           primary_key: true, required: true, format: /[a-z]{3}/
  field :name,         type: String, required: true
  field :base_url,     type: String, required: true
  field :pager_css,    type: String
  field :item_css,     type: String, required: true
  field :index_pages,  type: Set, required: true
  field :ssl,          type: Boolean

  alias_method :code,   :id
  alias_method :code=,  :id=
end