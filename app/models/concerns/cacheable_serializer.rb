module CacheableSerializer
  extend ActiveSupport::Concern

  # This required so that active model serializer do
  # not try to be smart and figuring out the serializer
  # With this method, this method will be called immediately
  # see ActiveModel::Serializer::serializer_for
  
  # Removing this mixin might cause active_model_serializer
  # querying database for every model even when model is already loaded

  # def serializer_class
  #   "#{self.class}Serializer".constantize
  # end
  
  module ClassMethods
    def cache_key
      to_s
    end
  end
end