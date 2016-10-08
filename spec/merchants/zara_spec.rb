require 'buyma_insider'
require 'minitest/autorun'

describe Zara do
  before do
    @zara = ::Zara.new
  end

  describe 'when crawl' do
    it 'must crawl' do
      @zara.crawl
    end
  end
end
