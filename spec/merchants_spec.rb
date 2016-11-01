require 'buyma_insider'
require 'minitest/autorun'

describe Merchant::Base do
  describe Merchant::Ssense do
    xit 'should crawl' do
      Merchant::Ssense.new.crawl
    end
  end

  describe Merchant::Zara do
    xit 'should crawl' do
      Merchant::Zara.new.crawl
    end
  end

  describe Merchant::Getoutside do
    xit 'should crawl' do
      Merchant::Getoutside.new.crawl
    end
  end

  describe Merchant::Shoeme do
    xit 'should crawl' do
      Merchant::Shoeme.new.crawl
    end
  end
end
