module JsonHelper
  def self.included(base_klazz)
    base_klazz.prepend(OverrideMethods)
  end
  
  module OverrideMethods
    def json(object, opts = {})
      defaults = Hash[:include, '**']
      if object
        opts = defaults.merge(opts) if settings.deep_serialization
        super ActiveModelSerializers::SerializableResource.new(object, opts),
              { json_encoder: :to_json }
      else
        not_found({ 'error' => 'No models was found with the request' }.to_json)
      end
    end
  end
end