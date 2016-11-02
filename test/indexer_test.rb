require 'ostruct'
require 'buyma_insider'
require 'minitest/autorun'

require_relative './setup_merchant'

# test_metadata = OpenStruct.new code: 'tta'
# test_merchant = Merchant::Base.new(test_metadata)

class IndexerTest < Minitest::Test
  def setup
    @metadatum = MerchantMetadata.load
    MerchantMetadata.stub :all, @metadatum do
      @all       = Merchant::Base.all
      @merchants = Merchant::Base.merchants
    end
  end

  def test_should_have_indexer
    @all.each do |m_klazz|
      refute_nil m_klazz.indexer
    end
  end

  def test_should_parse_getoutside_index
    indexer = Merchant::Indexer::Getoutside.new(
      'b', @merchants[:getoutside].metadata
    )

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
    assert_equal Array.new(5) { |idx| "#{@merchants[:getoutside].base_url}/b?p=#{idx+1}" }, indices
  end

  def test_should_parse_shoeme_index
    indexer = Merchant::Indexer::Shoeme.new(
      'b', @merchants[:shoeme].metadata
    )

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
    assert_equal Array.new(5) { |idx| "#{@merchants[:shoeme].base_url}/nav?initial_url=http://www.shoeme.ca/b&page=#{idx+1}" }, indices
  end

  def test_should_parse_ssense_index
    indexer = Merchant::Indexer::Ssense.new(
      'index', @merchants[:ssense].metadata
    )

    def indexer.index_document
      Nokogiri::HTML::DocumentFragment.parse <<-FRAG
        <div class="row-fluid vspace4 browsing-pagination" data-view="BrowsingPagination">
          <div class="span16 text-center">
            <div class="hidden-smartphone-landscape">
              <ul class="nav">
                <li class="hidden"><a href="/en-ca/men/pages/0">←</a></li>
                <li class="active">1</li>
                <li class=""><a href="/en-ca/men/pages/2">2</a></li>
                <li class=""><a href="/en-ca/men/pages/3">3</a></li>
                <li class=""><a href="/en-ca/men/pages/4">4</a></li>
                <li class=""><a href="/en-ca/men/pages/5">5</a></li>
                <li class=""><a href="/en-ca/men/pages/6">6</a></li>
                <li class=""><a href="/en-ca/men/pages/7">7</a></li>
                <li class="ellipsis">...</li>
                <li class="last-page"><a href="/en-ca/men/pages/8">8</a></li>
                <li class=""><a href="/en-ca/men/pages/2">→</a></li>
              </ul>
            </div>
            <div class="display-block-smartphone-landscape">
              <ul class="nav">
                <li class="hidden"><a href="/en-ca/men/pages/0">←</a></li>
                <li class="active">1</li>
                <li class=""><a href="/en-ca/men/pages/2">2</a></li>
                <li class=""><a href="/en-ca/men/pages/3">3</a></li>
                <li class=""><a href="/en-ca/men/pages/4">4</a></li>
                <li class=""><a href="/en-ca/men/pages/5">5</a></li>
                <li class=""><a href="/en-ca/men/pages/6">6</a></li>
                <li class=""><a href="/en-ca/men/pages/7">7</a></li>
                <li class=""><a href="/en-ca/men/pages/2">→</a></li>
              </ul>
            </div>
          </div>
        </div>
      FRAG
    end

    indices = []
    indexer.compute_page { |idx| indices << idx }
    assert_equal 8, indices.count
    assert_equal Array.new(8) { |idx| "#{@merchants[:ssense].base_url}/index/pages/#{idx+1}" }, indices
  end
end