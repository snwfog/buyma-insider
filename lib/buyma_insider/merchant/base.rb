require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'nokogiri'

module Merchant
  class Base
    include Concerns::Http
    include Concerns::Parser
    include Concerns::Processor
    include Concerns::UrlCache

    class << self
      attr_accessor :base_url
      attr_accessor :index_pages
      attr_accessor :item_xpath
      attr_accessor :article_model

      def base_url(url = nil)
        @base_url = url unless url.nil?
        @base_url
      end

      def index_page(index_address)
        @index_pages ||= []
        @index_pages << index_address
      end

      def item_xpath(path = nil)
        @item_xpath = path unless path.nil?
        @item_xpath
      end

      def article_model(model = nil)
        if model
          @article_model = model
        else
          m = %Q(#{self.to_s}Article)
          unless (@article_model = m.safe_constantize)
            @article_model = Article
          end
        end

        @article_model
      end
    end

    def index_pages
      self.class.index_pages
    end

    def item_xpath
      self.class.item_xpath
    end

    def article_model
      self.class.article_model
    end
  end
end
