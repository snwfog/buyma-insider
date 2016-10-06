require 'nokogiri'

module Indexer
  class Base
    class_attribute :pager_css

    attr_accessor :merchant
    attr_reader   :index_url

    def initialize(index_url)
      @index = URI("#{@merchant.base_url}/#{index_url}")
    end

    def index_document
      response = Http.get @index
      Nokogiri::HTML(response.body)
    end

    def index(&block)
      raise 'Not implemented'
    end
  end
end