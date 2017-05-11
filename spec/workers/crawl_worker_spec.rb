require_relative '../setup'

describe CrawlWorker do
  it 'should crawl' do
    CrawlWorker.new.perform(:ovo)
  end
end