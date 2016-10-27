require 'active_model_serializers'

class ArticleSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :price,
             :link,
             :description,
             :price_history
  # field :link,    k   type: String, required: true, length: (1..1000), format: %r(//.*)

  def price_history
    AMS::SerializableResource.new(object.price_history, adapter: :attributes)
  end
end