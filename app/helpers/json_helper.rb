require 'active_model_serializers'
module JsonHelper
  def self.included(base_klazz)
    base_klazz.prepend(OverrideMethods)
  end
  
  module OverrideMethods
    def json(object, options = {})
      if object
        options[:json_encoder] = :to_json
        super(ActiveModelSerializers::SerializableResource.new(object), options)
      else
        not_found({'Not found' => 'Model is not found'}.to_json)
      end
    end
  end
end