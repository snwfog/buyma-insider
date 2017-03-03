require 'rspec'
require 'minitest/mock'
require 'buyma_insider'

describe 'Merchant Website Checks' do
  before do
    @pages = {}
  end

  let(:pages) {
    Hash.new do |hash, key|
      merchant  = Merchant::Base[key]
      index     = merchant.indices.first.index_url
      response  = Http.get "http:#{index}"
      hash[key] = response
    end
  }

  it 'should reach merchant page and check first page' do
    merchants = Merchant::Base.all
    merchants.each do |merchant|
      expect(pages[merchant.name.to_sym].code).to be 200
    end
  end

  it 'should be able to parse index' do
    merchants = Merchant::Base.all.reject { |merchant| merchant.pager_css.nil? }
    merchants.each do |merchant|
      Http.stub :get, pages[merchant.name.to_sym] do
        indexer     = merchant.indexer.new('http://dummy.responsestub.com', merchant.metadatum)
        index_pages = indexer.compute_page {}.to_a
        expect(index_pages).to be_an_instance_of Array
      end
    end
  end
end
