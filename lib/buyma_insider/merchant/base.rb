require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'nokogiri'

module Merchant
  class Base
    class_attribute :base_url, :item_css

    class << self
      attr_accessor :article_model
      attr_accessor :index_pages

      def article_model
        @article_model ||= %Q(#{self.to_s}Article).safe_constantize || Article
      end

      def indexer
        %Q(Indexer::#{self.to_s}).safe_constantize
      end

      def index_pages=(indices)
        @index_pages = indices.map { |index_url|
          indexer.new(index_url, self)
        }
      end
    end

    def initialize(opts = {})
      @options = opts
      @crawler = CrawlExecutor.new(self.class)
    end

    def crawl
      @crawler.crawl

      puts @crawler.total_traffic_in_byte
      puts @crawler.total_merchant_items
    end
  end
end
