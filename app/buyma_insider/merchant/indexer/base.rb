require 'nokogiri'
require 'active_support/core_ext/module/delegation'

module Merchant
  module Indexer
    class Base
      delegate :pager_css, to: :metadata

      # www.merchant.com/shoe + pager style
      attr_accessor :metadata
      attr_accessor :index_path # 'shoe'
      attr_accessor :index_url # 'www.merchant.com'

      def initialize(index_path, metadata)
        @metadata   = metadata
        @index_path = index_path
        @index_url  = "#{metadata.base_url}/#{index_path}"
      end

      def index_document
        protocol = metadata.ssl ? 'https' : 'http'
        response = Http.get "#{protocol}:#{index_url}"
        Nokogiri::HTML(response.body)
      end

      def each_page(&blk)
        if pager_css.nil?
          yield @index_url
        else
          compute_page(&blk)
        end
      end

      # Use @index_url and compute the pages
      def compute_page(&blk)
        raise 'Indexer#compute_page should have block'
      end

      # @override
      def to_s
        index_url
      end
    end
  end
end