module Serializable
  extend ActiveSupport::Concern

  # This required so that active model serializer do
  # not try to be smart and figuring out the serializer
  # With this method, this method will be called imediately
  # see ActiveModel::Serializer::serializer_for

  # def serializer_class
  #   "#{self.class}Serializer".constantize
  # end
  module ClassMethods
    def cache_key
      to_s
    end
  end
end