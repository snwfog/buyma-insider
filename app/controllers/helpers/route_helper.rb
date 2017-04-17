module RouteHelper
  # Allow for filter with http method checking
  def self.included(klazz)
    klazz.instance_eval do
      set(:http_methods) do |*http_methods|
        http_methods.map!{|m| m.to_s.upcase}.freeze
        condition do
          http_methods.include?(request.request_method)
        end
      end
    end
  end
end