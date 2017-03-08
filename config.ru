require './app/buyma_insider'
require 'rake'
require 'rack'

# Auto-generate all routes from controller files
# Rake::FileList
#   .new(File.expand_path('../app/controllers/*_controller.rb', __FILE__))
#   .pathmap('%{_controller,}n')
#   .each do |route|
#     ctrl_class = "#{route}_controller".classify
#     map("/#{route}") { use ctrl_class.constantize }
# end

map_controller('/merchant_metadata')
map_controller('/crawl_histories')
map_controller('/crawl_sessions')
map_controller('/articles')
map_controller('/exchange_rates')
