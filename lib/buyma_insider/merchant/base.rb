require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'nokogiri'

module Merchant
  class Base
    class_attribute :base_url,
                    :index_pages,
                    :item_css,
                    :pager_css
    class << self
      attr_accessor :article_model
      attr_accessor :indexer

      def article_model
        @article_model ||= %Q(#{self.to_s}Article).safe_constantize || Article
      end

      def indexer
        @index = %Q(Indexer::#{self.to_s}Indexer).safe_constantize.new
      end
    end

    def initialize(opts = {})
      @options = opts
      @crawler = CrawlExecutor.new(self.class)
    end

    def crawl
      @crawler.crawl
    end
  end
end
