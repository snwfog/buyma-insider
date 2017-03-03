require 'nobrainer'

class MerchantMetadatum
  include NoBrainer::Document

  has_many :crawl_histories, scope: -> { order_by(created_at: :desc) }

  has_many :crawl_sessions, scope: -> { order_by(created_at: :desc) }

  has_many :articles

  field :id,           primary_key: true, required: true, format: /[a-z]{3}/
  field :name,         type: String, required: true
  field :base_url,     type: String, required: true
  field :pager_css,    type: String
  field :item_css,     type: String, required: true
  field :index_pages,  type: Set, required: true
  field :ssl,          type: Boolean

  alias_method :code,   :id
  alias_method :code=,  :id=

  def shinchyaku
    # This is a flat criteria, might look wrong
    # but its working
    articles.shinchyaku
  end

  def yasuuri
    articles.yasuuri
  end
end