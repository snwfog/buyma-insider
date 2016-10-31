require 'buyma_insider'
require 'minitest/autorun'

class TestMerchant_A < Merchant::Base
  self.code     = 'tta'
  self.base_url = '//test.com'
end

class IndexerTest < Minitest::Test
  def test_should_parse_getoutside_index
    indexer = Indexer::Getoutside.new('b', TestMerchant_A)
    def indexer.index_document
      Nokogiri::HTML::DocumentFragment.parse <<-FRAG
        <div class="pager">
          <div class="pages gen-direction-arrows1">
            <strong>Page:</strong>
            <ol>
              <li class="current">1</li>
              <li><a href="http://www.getoutsideshoes.com/mens/boots.html?p=2">2</a></li>
              <li><a href="http://www.getoutsideshoes.com/mens/boots.html?p=3">3</a></li>
              <li><a href="http://www.getoutsideshoes.com/mens/boots.html?p=4">4</a></li>
              <li><a href="http://www.getoutsideshoes.com/mens/boots.html?p=5">5</a></li>
              <li class="next">
                <a class="next i-next" href="http://www.getoutsideshoes.com/mens/boots.html?p=2" title="Next">Next</a>
              </li>
            </ol>
          </div>
        </div>
      FRAG
    end

    indices = []
    indexer.compute_page { |idx| indices << idx }
    assert_equal 5, indices.count
    assert_equal Array.new(5) { |idx| "//test.com/b?p=#{idx+1}" }, indices
  end

  def test_should_parse_shoeme_index
    indexer = Indexer::Shoeme.new('b', TestMerchant_A)

    def indexer.index_document
      Nokogiri::HTML::DocumentFragment.parse <<-FRAG
        <div class="nxt-pagination">
          <ul>
            <li><span class="nxt-current">1</span></li>
            <li><a href="http://www.shoeme.ca/collections/womens-shoesnav/page-2">2</a></li>
            <li><a href="http://www.shoeme.ca/collections/womens-shoesnav/page-3">3</a></li>
            <li><a class="nxt-pages-next" href="http://www.shoeme.ca/collections/womens-shoesnav/page-2">Next <span class="nxt-pages-caret"></span></a></li>
            <li><a class="nxt-pages-next" href="http://www.shoeme.ca/collections/womens-shoesnav/page-5">Last <span class="nxt-pages-caret"></span></a></li>
          </ul>
        </div>
      FRAG
    end

    indices = []
    indexer.compute_page { |idx| indices << idx }
    assert_equal 5, indices.count
    assert_equal Array.new(5) { |idx| "//test.com/nav?initial_url=http://www.shoeme.ca/b&page=#{idx+1}" }, indices
  end
end