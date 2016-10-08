require 'nokogiri'
module Indexer
  class Base
    class_attribute :pager_css

    attr_accessor :merchant
    attr_reader   :index
    attr_reader   :index_url

    def initialize(index_url, m)
      @merchant  = m
      @index_url = index_url # Index path
      @index     = URI("#{@merchant.base_url}/#{index_url}")
    end

    def index_document
      response = Http.get @index.to_s
      Nokogiri::HTML(response.body)
    end

    def each_page(&blk)
      compute_page(&blk)
    end

    def compute_page(&blk)
      raise 'Not implemented'
    end
  end
end