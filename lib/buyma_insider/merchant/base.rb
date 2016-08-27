require 'nokogiri'

module Merchant
  class Base
    include Concerns::Http
    include Concerns::Parser

    class << self
      attr_accessor :index_pages
      attr_accessor :item_xpath

      def index_page(index_address)
        @index_pages ||= []
        @index_pages << index_address
      end

      ##
      # Return or set the item path
      #
      def item_xpath(path = nil)
        @item_xpath ||= path
      end
    end

    def initialize
      @index_pages = []
    end

    def index_pages
      self.class.index_pages
    end

    def item_xpath
      self.class.item_xpath
    end
  end
end
