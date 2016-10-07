require 'rspec'
require 'buyma_insider'

describe Ssense do
  before do
    @ssense = Ssense.new
  end

  describe 'when crawl' do
    it 'must crawl' do
      @ssense.crawl
    end
  end
end
