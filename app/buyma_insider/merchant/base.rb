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
        merchant.extend "Merchant::ArticleParser::#{meta.name_capitalized}".safe_constantize
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
          # NOTE:
          # A polymorphic problem has been detected: The fields `[:id]' are defined on `Article'.
          # This is problematic as first_or_create() could return nil in some cases.
          #   Either 1) Only define `[:id]' on `SsenseArticle',
          #   or     2) Query the superclass, and pass :_type in first_or_create() as such:
          #             `Article.where(...).first_or_create(:_type => "SsenseArticle")'.
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
