require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'nokogiri'

module Merchant
  class Base
    class << self
      attr_accessor :base_url, :index_pages, :item_css,
                    :pager_css, :article_model

      def base_url(url = nil)
        @base_url = url unless url.nil?
        @base_url
      end

      def index_page(index_address)
        @index_pages ||= []
        @index_pages << index_address
      end

      def item_css(path = nil)
        @item_css = path unless path.nil?
        @item_css
      end

      def pager_css(path = nil)
        @pager_css = path unless path.nil?
        @pager_css
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

    delegate :base_url, :index_pages, :item_css,
             :pager_css, :article_model, to: :class

    def initialize(options = {})
      @options = options
    end
  end
end
