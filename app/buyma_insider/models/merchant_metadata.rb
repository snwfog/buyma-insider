require 'nokogiri'
require 'nobrainer'

require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/class/attribute'
require 'active_support/descendants_tracker'

class MerchantMetadata
  include NoBrainer::Document
  
  has_many :crawl_history
  
  field :id,           primary_key: true, required: true, format: /[a-z]{3}/
  field :name,         type: String, required: true
  field :base_url,     type: String, required: true
  field :pager_css,    type: String, required: true
  field :item_css,     type: String, required: true
  field :index_pages,  type: Set, required: true
  
  alias_method :code, :id
  alias_method :code=, :id=
  
  before_initialize {
    @logger = Logging.logger[self]
  }

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
end