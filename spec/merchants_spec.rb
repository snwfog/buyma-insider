require 'rspec'
require 'buyma_insider'

describe Merchant::Base do
  it 'should have metadata' do
    expect(MerchantMetadatum.all.count).to be(4)
  end

  it 'should list all merchant' do
    expect(Merchant::Base.all.count).to be 4
    expect(Merchant::Base.merchants_lookup.keys.count).to be 4
  end

  it 'should fetch merchant' do
    expect(Merchant::Base[:getoutside]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:shoeme]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:zara]).to be_an_instance_of(Merchant::Base)
    expect(Merchant::Base[:ssense]).to be_an_instance_of(Merchant::Base)
  end

  xit 'should crawl' do
    Merchant::Base[:ssense].crawl
  end
end
