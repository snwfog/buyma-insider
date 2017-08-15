class Merchant < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  has_many :index_pages, dependent: :destroy
  
  has_one :merchant_metadatum, dependent: :destroy
end