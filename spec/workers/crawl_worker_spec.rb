require_relative '../setup'

describe MerchantCrawlWorker do
  it 'should crawl' do
    MerchantCrawlWorker.new.perform(:ovo)
  end
end