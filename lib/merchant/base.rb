require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchant
  class Base
    delegate :id, :code, :name, :base_url,
             :pager_css, :item_css, :index_pages,
             to: :metadatum

    class_attribute :indexer
    
    def self.all
      @@all ||= MerchantMetadatum.all.map do |meta|
        merchant = new(meta)
        merchant.extend("Merchant::#{meta.name.capitalize}".safe_constantize)
      end
    end

    def self.merchants
      @@merchants ||= Hash[all.collect { |m| [m.name.to_sym, m] }]
    end

    def self.[](merchant_name)
      merchants[merchant_name.to_sym]
    end

    attr_accessor :metadatum

    def initialize(metadatum)
      @metadatum = metadatum
    end

    def indices
      @indices ||= index_pages.map { |path|
        indexer.new(path, metadatum)
      }
    end
  end
end
