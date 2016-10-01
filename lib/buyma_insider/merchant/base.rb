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

      def article_model
        @article_model ||= %Q(#{self.to_s}Article).safe_constantize || Article
      end
    end

    def initialize(opts = {})
      @options  = opts
      @executor = CrawlExecutor.new(self)
    end

    def crawl
      @executor.crawl
    end
  end
end
