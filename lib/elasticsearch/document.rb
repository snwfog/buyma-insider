require 'nobrainer'

module Elasticsearch
  module Document
    def self.included(klazz)
      if klazz < NoBrainer::Document
        klazz.class_eval do
          alias_method :to_h, :attributes
          
          after_create :index_elasticsearch_document, if: :changed?
          after_update :index_elasticsearch_document, if: :changed?
          after_destroy :delete_elasticsearch_document
          
          [:index, :delete].each do |op|
            define_method("#{op}_elasticsearch_document") do
              ::Elasticsearch::IndexDocumentWorker.perform_async(self, op)
            end
          end
        end
      end
    end
  end
end
