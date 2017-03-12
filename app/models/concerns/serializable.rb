module Serializable
  extend ActiveSupport::Concern

  def serializer_class
    "#{self.class}Serializer".constantize
  end
end