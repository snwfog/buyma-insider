require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'active_support/descendants_tracker'
require 'nokogiri'

module Merchant
  class Base
    extend ActiveSupport::DescendantsTracker

    class_attribute :base_url
    class_attribute :item_css

    class << self
      attr_accessor :article_model
      attr_accessor :index_pages

      def indexer
        @indexer ||= %Q(Indexer::#{self.to_s}).safe_constantize
      end

      def index_pages=(indices)
        @index_pages = indices.map { |path| indexer.new(path, self) }
      end

      def article_model
        @article_model ||= "#{self.to_s}Article".safe_constantize || raise('Article model not found')
      end
    end

    def initialize(opts = {})
      @options = opts
      @logger  = Logging.logger[self]
    end

    def crawl
      crawler = Crawler.new(self.class)
      crawler.crawl do |history, attrs|
        merchant_article    = self.class.article_model.new(attrs)
        history.items_count += 1
        if merchant_article.valid?
          # NOTE:
          # A polymorphic problem has been detected: The fields `[:id]' are defined on `Article'.
          # This is problematic as first_or_create() could return nil in some cases.
          #   Either 1) Only define `[:id]' on `SsenseArticle',
          #   or     2) Query the superclass, and pass :_type in first_or_create() as such:
          #             `Article.where(...).first_or_create(:_type => "SsenseArticle")'.
          article = Article.upsert!(attrs)
          @logger.debug "Saved #{article.inspect}"
        else
          @logger.warn "Invalid article, #{merchant_article.errors.messages}"
          @logger.warn "Skipping... #{merchant_article.inspect}"
          history.invalid_items_count += 1
        end
      end

      crawler
    end
  end
end
