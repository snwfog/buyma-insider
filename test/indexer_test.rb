require 'buyma_insider'
require 'minitest/autorun'

class TestMerchantA < Merchant::Base
  self.base_url = '//test.com'
end

class IndexerTest < Minitest::Test
  def test_should_parse_getoutside_index
    indexer = Indexer::Getoutside.new('b', TestMerchantA)
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
    indexer = Indexer::Shoeme.new('b', TestMerchantA)

    def indexer.index_document
      Nokogiri::HTML::DocumentFragment.parse <<-FRAG
        <div class="nxt-pagination">
          <ul>
            <li><span class="nxt-current">1</span></li>
            <li><a href="?Features=Ankle+Boots+%26+Booties&amp;Subcategory=Ankle+%26+Short+Boots&amp;search_return=all&amp;page=2">2</a></li>
            <li><a href="?Features=Ankle+Boots+%26+Booties&amp;Subcategory=Ankle+%26+Short+Boots&amp;search_return=all&amp;page=3">3</a></li>
            <li><a class="nxt-pages-next" href="?Features=Ankle+Boots+%26+Booties&amp;Subcategory=Ankle+%26+Short+Boots&amp;search_return=all&amp;page=2">Next</a></li>
            <li><a class="nxt-pages-next" href="?Features=Ankle+Boots+%26+Booties&amp;Subcategory=Ankle+%26+Short+Boots&amp;search_return=all&amp;page=38">Last</a></li>
          </ul>
        </div>
      FRAG
    end

    indices = []
    indexer.compute_page { |idx| indices << idx }
    assert_equal 38, indices.count
    assert_equal Array.new(38) { |idx| "//test.com/b/\#/?page=#{idx+1}" }, indices
  end
end