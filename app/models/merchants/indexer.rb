require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchants
  class Indexer
    delegate :pager_css, to: :merchant_metadatum
    
    # www.merchant.com/shoe + pager style
    attr_accessor :merchant_metadatum
    attr_accessor :index_path # 'shoe'
    attr_accessor :index_url # 'www.merchant.com'
    
    def initialize(index_path, metadatum)
      @merchant_metadatum = metadatum
      @index_path         = index_path
      @index_url          = "#{merchant_metadatum.base_url}/#{index_path}"
    end
    
    def index_document
      protocol = merchant_metadatum.ssl ? 'https' : 'http'
      response = Http.get "#{protocol}:#{index_url}"
      Nokogiri::HTML(response.body)
    end
    
    def each_page(opts = {}, &blk)
      if !pager_css
        yield @index_url
      else
        compute_page(&blk)
      end
    end
    
    # Use @index_url and compute the pages
    def compute_page(&blk)
      raise 'Indexer#compute_page requires a block parameter' unless block_given?
      raise 'Indexer#compute_page is not implemented'
    end
    
    def to_s
      index_url
    end
  end
end