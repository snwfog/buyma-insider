require 'buyma_insider'
require 'minitest/autorun'

describe Merchant::Base do
  describe ::Ssense do
    xit 'should crawl' do
      ::Ssense.new.crawl
    end
  end

  describe ::Zara do
    xit 'should crawl' do
      ::Zara.new.crawl
    end
  end

  describe ::Getoutside do
    xit 'should crawl' do
      ::Getoutside.new.crawl
    end
  end

  describe ::Shoeme do
    it 'should crawl' do
      ::Shoeme.new.crawl
    end
  end
end
