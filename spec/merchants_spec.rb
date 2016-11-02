require 'rspec'
require 'buyma_insider'

describe Merchant::Base do
  it 'should have metadata' do
    expect(MerchantMetadata.all.count).to be(4)
  end

  it 'should list all merchants' do
    expect(Merchant::Base.all.count).to be 4
    expect(Merchant::Base.merchants.keys.count).to be 4
  end

  it 'should fetch merchants' do
    expect(Merchant::Base[:getoutside]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:shoeme]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:zara]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:ssense]).to be_an_instance_of(Merchant::Base)
  end

  it 'should crawl' do
    Merchant::Base[:getoutside].crawl
  end
end
