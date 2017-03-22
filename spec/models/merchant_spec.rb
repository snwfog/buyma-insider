require_relative '../setup'

describe Merchant do
  it 'should get first' do
    Merchant.first === Merchant
  end
  
  it 'should all' do
    Merchant.all === Array
  end
end