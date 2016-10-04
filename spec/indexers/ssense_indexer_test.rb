require 'nokogiri'
require 'buyma_insider'
require 'minitest/autorun'

class SsenseIndexerTest < Minitest::Test
  def setup
    @index_html = <<-INDEX_HTML
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
    INDEX_HTML

    @pages_node = Nokogiri::HTML::DocumentFragment.parse(@index_html)
    @indexer = Indexer::SsenseIndexer.new

    @ssense_stub = Minitest::Mock.new
    def @ssense_stub.pager_css; 'ul.nav'; end
  end

  def test_ssense_indexer_test
    yield_count = 0
    @indexer.index(@pages_node, @ssense_stub) do
      yield_count += 1
    end

    assert_equal 8, yield_count
  end
end
