class MerchantMetadatum
  include NoBrainer::Document
  include CacheableSerializer

  belongs_to :merchant, required: true,
                        unique:   true

  field :id,           primary_key: true
  
  field :name,         type:     String,
                       required: true
  
  field :domain,       type:     String,
                       required: true,
                       format:   %r{//[^/]+}
  
  field :pager_css,    type: String
  
  field :item_css,     type:     String,
                       required: true

  field :ssl,          type:        Boolean,
                       default:     false
  # field :index_pages,  type: Set, required: true
  # field :ssl,          type: Boolean

  alias_method :code,   :id
  alias_method :code=,  :id=

  def latests
    # This is a flat criteria, might look wrong
    # but its working
    # articles.shinchyaku
  end

  def sales
    # articles.sales
  end
end