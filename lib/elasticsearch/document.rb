require 'nobrainer'

module BuymaInsider
  module Elasticsearch
  module Document
    def self.included(klazz)
      if klazz < NoBrainer::Document
        klazz.class_eval do
          alias_method :to_h, :attributes
          
          after_create :index_elasticsearch_document
          
          def index_elasticsearch_document
            Elasticsearch::DocumentIndexWorker.perform_async(self)
          end
        end
      end
    end
  end
  end
end
