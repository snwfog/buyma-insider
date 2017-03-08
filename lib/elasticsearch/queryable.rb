require 'elasticsearch'

module BuymaInsider
  module Elasticsearch
    module Queryable
      def elastic_client
        @elastic_client ||= ::Elasticsearch::Client.new
      end
    end
  end
end