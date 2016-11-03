require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchant
  class Base
    delegate :id, :code, :name, :base_url,
             :pager_css, :item_css, :index_pages,
             to: :metadata

    def self.all
      @@all ||= MerchantMetadata.all.map do |meta|
        merchant = Merchant::Base.new(meta)
        merchant.extend "Merchant::ArticleParser::#{meta.name.capitalize}".safe_constantize
      end
    end

    def self.merchants
      @@merchants ||= Hash[all.collect { |m| [m.name.to_sym, m] }]
    end

    def self.[](merchant_sym)
      merchants[merchant_sym]
    end

    attr_accessor :metadata

    def initialize(metadata, opts = {})
      @metadata = metadata
      @options  = opts
      @logger   = Logging.logger[self]
    end

    def indices
      @indices ||= index_pages.map { |path| indexer.new(path, metadata) }
    end

    def indexer
      @indexer ||= %Q(::Merchant::Indexer::#{name.capitalize}).safe_constantize
    end

    def crawl
      crawler = Crawler.new(self)
      crawler.crawl do |history, attrs|
        begin
          article             = Article.upsert!(attrs)
          history.items_count += 1
          @logger.debug "Saved #{article.inspect}"
        rescue Exception => ex
          @logger.warn ex
          @logger.warn attrs
          history.invalid_items_count += 1
        end
      end
      crawler
    end
  end
end
