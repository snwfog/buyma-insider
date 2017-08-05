require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchants
  class Indexer
    attr_accessor :index_page
    attr_accessor :merchant
    attr_accessor :merchant_metadatum

    def initialize(index_page)
      @index_page         = index_page
      @merchant           = @index_page.merchant
      @merchant_metadatum = @merchant.metadatum
    end

    def index_document
      if cache_index_document = @index_page.cache_html_document
        Nokogiri::HTML(cache_index_document)
      else
        nil
      end
    end

    def pager_node
      index_document&.at_css(@merchant_metadatum.pager_css)
    end

    def compute!
      if pager_node
        compute_index_page
      else
        []
      end
    end

    # returns index pages as array
    def compute_index_page
      raise 'Indexer#compute_page is not implemented'
    end
  end
end