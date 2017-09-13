require_relative './setup'

describe 'Merchant Indexer' do
  before do
    unless File.exists?(index_page.cache.path)
      IndexPageCrawlWorker.new.perform('index_page_id' => index_page.id)
    end
  end

  context 'ssense' do
    let(:index_page) { IndexPage.where(relative_path: '/en-ca/men').first! }
    it 'should parse all index pages from an index page' do
      indexer     = Merchants::Ssense::SsenseIndexer.new(index_page)
      index_pages = indexer.compute_index_page
      expect(index_pages).to have(96).index_pages
    end
  end

  context 'livestock' do
    let(:index_page) { IndexPage.where(relative_path: '/collections/new-arrivals').first! }
    it 'should parse all index pages from an index page' do
      indexer     = Merchants::Livestock::LivestockIndexer.new(index_page)
      index_pages = indexer.compute_index_page
      expect(index_pages).to have(3).index_pages
    end
  end
end