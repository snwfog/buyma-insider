module Merchant
  class Base
    include Concerns::Crawler::Http

    attr_accessor :index_pages

    def initialize
      @index_pages = []
    end

    def index_page(index_address)
      @index_pages << index_address
    end
  end
end
