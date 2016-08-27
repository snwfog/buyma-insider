require 'nokogiri'

module Merchant
  class Base
    include Concerns::Crawler::Http

    attr_accessor :document

    class << self
      attr_accessor :index_pages

      def index_page(index_address)
        @index_pages ||= []
        @index_pages << index_address
      end
    end

    def initialize
      @index_pages = []
    end

    def index_pages
      self.class.index_pages
    end

    def parse
      @document = Nokogiri::HTML(@response.body)
    end

    def item_path
      raise 'Not implemented'
    end
  end
end
