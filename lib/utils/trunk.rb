def map_controller(route)
  map("/#{BuymaInsider::API_VERSION}" + route) do
    run "#{route}_controller".classify.constantize
  end
end

