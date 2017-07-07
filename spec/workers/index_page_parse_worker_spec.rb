require_relative '../setup'

describe IndexPageParseWorker do
  it 'should parse and create articles' do
    crawl_history = CrawlHistory.where(status: :completed).first
    IndexPageParseWorker.new.perform(crawl_history.id)
  end
end