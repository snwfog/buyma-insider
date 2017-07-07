require_relative '../setup'

describe IndexPageCrawlWorker do
  let(:ovo) { Merchant.find(:ovo) }
  it 'should crawl' do
    index_page = ovo.index_pages.first
    IndexPageCrawlWorker.new.perform('index_page_id' => index_page.id)
  end
end