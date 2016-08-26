module Merchant
  class Base
    include Concerns::Crawler::Http

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
  end
end
