# == Schema Information
#
# Table name: price_histories
#
#  id         :integer          not null, primary key
#  article_id :integer          not null
#  price      :decimal(18, 5)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PriceHistory < ActiveRecord::Base
  DEFAULT_CURRENCY = :CAD

  belongs_to :article, touch: true

  scope :latest, -> { order(created_at: :desc).take }
  scope :max, -> { order(price: :desc).take }
  scope :min, -> { order(price: :asc).take }

  validates_numericality_of :price

  def price=(price)
    super price.to_s.tr('^0-9.', ?_).to_f
  end
end
