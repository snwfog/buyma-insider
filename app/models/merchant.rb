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
end
