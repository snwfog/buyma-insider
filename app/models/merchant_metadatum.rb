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

class MerchantMetadatum < ActiveRecord::Base
  belongs_to :merchant

  alias_attribute :base_url, :domain

  def latests
    raise
  end

  def sales
    raise
  end

  def full_url
    scheme << ':' << domain
  end

  def scheme
    ssl? ? 'https' : 'http'
  end
end
