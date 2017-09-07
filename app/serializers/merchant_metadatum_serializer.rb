# == Schema Information
#
# Table name: merchant_metadata
#
#  id          :integer          not null, primary key
#  merchant_id :integer          not null
#  domain      :string(2000)     not null
#  pager_css   :string(1000)
#  item_css    :string(1000)
#  ssl         :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MerchantMetadatumSerializer < ActiveModel::Serializer
  cache key: :merchant_metadatum, expires_in: 1.day

  attributes :id,
             :name,
             :domain,
             :pager_css,
             :item_css,
             :ssl
  
             # :new_articles_count,
             # :last_sync_at

  # def new_articles_count
  #   # This is a chained criteria, not method call
  #   object.shinchyaku.count
  # end
  def name
    object.merchant.name
  end
end
