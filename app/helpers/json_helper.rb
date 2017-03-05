module JsonHelper
  def render_json(model, options = {})
    if model
      json AMS::SerializableResource.new(model, options)
    else
      not_found
    end
  end
end