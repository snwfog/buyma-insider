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

  default_scope { eager_load(:merchant_metadatum) }

  after_find do
    extend "Merchants::#{name.capitalize}".safe_constantize
  end

  class_attribute :indexer

  delegate :domain, :pager_css, :item_css, to: :merchant_metadatum

  alias_attribute :metadatum, :merchant_metadatum
  alias_attribute :meta, :merchant_metadatum
end
