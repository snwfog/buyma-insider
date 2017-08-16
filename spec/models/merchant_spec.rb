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

require_relative '../setup'

describe Merchant do
  it 'should get first' do
    Merchant.first === Merchant
  end
  
  it 'should all' do
    Merchant.all === Array
  end
end
