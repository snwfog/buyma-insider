require_relative '../setup'

describe ArticleParseWorker do
  it 'should parse and create articles' do
    crawl_history = CrawlHistory.where(status: :completed).first
    ArticleParseWorker.new.perform(crawl_history.id)
  end
end