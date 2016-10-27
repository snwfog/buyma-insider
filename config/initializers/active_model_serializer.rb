require 'active_model_serializers'

AMS = ::ActiveModelSerializers unless defined? :AMS

ActiveModelSerializers.config.adapter       = :json_api
ActiveModelSerializers.config.key_transform = :underscore
