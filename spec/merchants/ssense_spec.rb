require 'buyma_insider'
require 'minitest/autorun'

describe Ssense do
  before do
    @ssense = ::Ssense.new
  end

  describe 'when crawl' do
    xit 'must crawl' do
      @ssense.crawl
    end
  end
end
