module ElasticsearchSync
  extend ActiveSupport::Concern
  
  def self.included(model_class)
    model_class.class_eval do
      alias_method :to_h, :attributes
      
      after_create  :index_elasticsearch_document, if: :changed?
      after_update  :index_elasticsearch_document, if: :changed?
      after_destroy :index_elasticsearch_document
      
      def index_elasticsearch_document
        stack_regexp = %r(/no_brainer/document/callbacks)
        if stack_line = caller.grep(stack_regexp)&.first
          operation = case stack_line.split.pop
                      when /create/
                        :create
                      when /update/
                        :update
                      when /destroy/
                        :destroy
                      else
                        logger.error { 'Unrecognized model operation callback `%s`' % operation }
                      end
          ::Elasticsearch::IndexDocumentWorker.perform_async(id, operation)
        else
          logger.error { 'Could not find model callback in stacktraces `%s`' % caller }
        end
      end
      
      # [:index, :delete].each do |method|
      #   define_method("#{method}_elasticsearch_document") do
      #     ::Elasticsearch::IndexDocumentWorker.perform_async(id, method)
      #   end
      # end
    end
  end
end