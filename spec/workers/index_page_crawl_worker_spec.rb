require_relative '../setup'

describe IndexPageCrawlWorker do
  let(:ovo) { Merchant.find(:ovo) }
  it 'should crawl' do
    index_page = ovo.index_pages.first
    IndexPageCrawlWorker.new.perform('index_page_id' => index_page.id)
  end

  it 'should reach index page' do
    standard_headers = {
      x_forwarded_for:  Faker::Internet.ip_v4_address,
      x_forwarded_host: Faker::Internet.ip_v4_address,
      user_agent:       BuymaInsider::SPOOF_USER_AGENT,
      accept_encoding:  'gzip',
      cache_control:    'no-cache',
      pragma:           'no-cache'
    }

    RestClient::Request.execute(url:          'https://www.zara.com/ca/en/woman/new-in-c840002.html',
                                method:       :get,
                                verify_ssl:   true,
                                raw_response: true,
                                headers:      standard_headers)
  end
end