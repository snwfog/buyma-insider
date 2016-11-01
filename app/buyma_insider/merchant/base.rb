require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchant
  class Base
    delegate :id, :code, :name, :base_url,
             :pager_css, :item_css, :index_pages,
             to: :metadata
    
    def self.all_merchants
      @@all_merchants ||= MerchantMetadata.all.map do |meta|
        Merchant::Base.new(meta)
      end
    end
    
    def initialize(metadata, opts = {})
      @metadata = metadata,
        @options = opts
      @logger   = Logging.logger[self]
    end
    
    def indices
      @indices ||= index_pages.map { |path| indexer.new(path, self) }
    end
    
    def indexer
      @indexer ||= %Q(::Merchant::Indexer::#{name.capitalize}).safe_constantize
    end
    
    def crawl
      crawler = Crawler.new(self)
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
  end
end
