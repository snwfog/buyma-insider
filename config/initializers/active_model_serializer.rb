require 'active_model_serializers'

AMS = ::ActiveModelSerializers unless defined? AMS

AMS.config.adapter       = :json_api
# AMS.config.key_transform = :underscore

