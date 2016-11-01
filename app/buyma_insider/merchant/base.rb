require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'active_support/descendants_tracker'
require 'nokogiri'

module Merchant
  class Base
    include NoBrainer::Document
    extend ActiveSupport::DescendantsTracker

    has_many :crawl_history, foreign_key: :merchant_id

    field :id,    primary_key: true, required: true, format: /[a-z]{3}/
    field :name,  type: String, required: true

    class_attribute :base_url
    class_attribute :item_css
    class_attribute :code

    alias_method :code, :id

    class << self
      attr_accessor :index_pages

      def indexer
        merchant_name = to_s.split('::').last
        @indexer ||= %Q(::Merchant::Indexer::#{merchant_name}).safe_constantize
        raise 'Indexer not found' if @indexer.nil?
        @indexer
      end

      def index_pages=(indices)
        @index_pages = indices.map { |path| indexer.new(path, self) }
      end
    end

    def initialize(opts = {})
      @options = opts
      @logger  = Logging.logger[self]
    end

    def crawl
      crawler = Crawler.new(self.class)
      crawler.crawl do |history, attrs|
        merchant_article    = Article.new(attrs)
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

    # BUG: Hack, otherwise inspect breaks...
    def to_s
      "#<#{self.class}>"
    end
  end
end
