require 'active_model_serializers'
module JsonHelper
  def self.included(base_klazz)
    base_klazz.prepend(OverrideMethods)
  end
  
  module OverrideMethods
    def json(object, options = {})
      if object
        options = options.merge({ include: '**' }) if settings.deep_serialization
        super ActiveModelSerializers::SerializableResource.new(object, options),
              { json_encoder: :to_json }
      else
        not_found({ 'Not found' => 'No models was found with the request' }.to_json)
      end
    end
  end
end