require 'buyma_insider'
require 'minitest/autorun'

describe Zara do
  before do
    @zara = ::Zara.new
  end

  describe 'when crawl' do
    it 'must crawl' do
      crawler = @zara.crawl
      crawler.stats
      crawler.total_elapsed_time
    end
  end
end
