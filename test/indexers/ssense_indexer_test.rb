require 'nokogiri'
require 'buyma_insider'
require 'minitest/autorun'

class SsenseIndexerTest < Minitest::Test
  def setup
    @indexer    = Indexer::Ssense.new 'http://merchant-a.com/index.html', Ssense
    def Http.get(link)
      mock_response = Minitest::Mock.new

      def mock_response.body
        <<-INDEX_HTML
          <html><body>
            <ul class="nav">
              <li class="hidden"><a href="/en-ca/men/pages/0">←</a></li>
              <li class="active">1 </li>
              <li class=""><a href="/en-ca/men/pages/2">2</a></li>
              <li class=""><a href="/en-ca/men/pages/3">3</a></li>
              <li class=""><a href="/en-ca/men/pages/4">4</a></li>
              <li class=""><a href="/en-ca/men/pages/5">5</a></li>
              <li class=""><a href="/en-ca/men/pages/6">6</a></li>
              <li class=""><a href="/en-ca/men/pages/7">7</a></li>
              <li class="ellipsis">...</li>
              <li class="last-page"><a href="/en-ca/men/pages/8">8</a></li>
              <li class=""><a href="/en-ca/men/pages/2">→</a>
              </li>
            </ul>
          </body></html>
        INDEX_HTML
      end

      mock_response
    end
  end

  def test_ssense_indexer_test
    yield_count = 0

    Indexer::Ssense.stub :pager_css, 'ul.nav' do
      @indexer.index do
        yield_count += 1
      end
    end

    assert_equal 8, yield_count
  end
end
