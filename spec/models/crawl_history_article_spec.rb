require_relative '../setup'

describe CrawlHistoryArticle do
  it 'must be unique article per crawl history' do
    index_page = Merchant.find(:ltk).index_pages.first
    ch         = CrawlHistory.create!(index_page:  index_page,
                                      description: 'it-test crawl history')
    article    = get_article
    article.save!

    expect { CrawlHistoryArticle.create!(crawl_history: ch,
                                         article:       article,
                                         status:        :created) }.to_not raise_error

    expect { CrawlHistoryArticle.create!(crawl_history: ch,
                                         article:       article,
                                         status:        :created) }.to raise_error NoBrainer::Error::DocumentInvalid
  end
end
