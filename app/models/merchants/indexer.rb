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
      if @index_page.has_web_cache?
        Nokogiri::HTML(@index_page.cache_html_document)
      else
        raise <<~ERROR
          Indexer was supplied with an index page without cache.
          #{index_page} cache at location #{index_page.cache_html_path} does not exists."
        ERROR
      end
    end

    def pager_node
      index_document.at_css(@merchant_metadatum.pager_css)
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