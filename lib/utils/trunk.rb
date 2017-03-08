def map_controller(route)
  map(route) do
    run "#{route}_controller".classify.constantize
  end
end

