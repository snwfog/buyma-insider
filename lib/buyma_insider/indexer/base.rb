require 'nokogiri'
module Indexer
  class Base
    class_attribute :pager_css

    attr_accessor :merchant
    attr_reader :index_url
    attr_reader :index_path

    def initialize(path, m)
      @merchant   = m
      @index_path = path # Index path
      @index_url  = "#{@merchant.base_url}/#{path}"
    end

    def index_document
      response = Http.get @index_url
      Nokogiri::HTML(response.body)
    end

    def each_page(&blk)
      compute_page(&blk)
    end

    def compute_page(&blk)
      raise 'Not implemented'
    end

    # override
    def to_s
      "#{@index_url}"
    end
  end
end