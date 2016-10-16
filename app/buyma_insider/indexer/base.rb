require 'nokogiri'

module Indexer
  class Base
    class_attribute :pager_css

    attr_accessor :merchant_klazz
    attr_reader :index_url
    attr_reader :index_path

    def initialize(path, merchant_klazz)
      @merchant_klazz   = merchant_klazz
      @index_path = path # Index path
      @index_url  = "#{merchant_klazz.base_url}/#{path}"
    end

    def index_document
      response = Http.get "http:#{@index_url}"
      Nokogiri::HTML(response.body)
    end

    def each_page(&blk)
      if self.class.pager_css.nil?
        yield @index_url
      else
        compute_page(&blk)
      end
    end

    # Use @index_url and compute the pages
    def compute_page(&blk)
      raise 'Not implemented'
    end

    # override
    def to_s
      "#{@index_url}"
    end
  end
end