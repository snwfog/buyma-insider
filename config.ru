require 'sidekiq/web'

require_relative './config/application'

# Auto-generate all routes from controller files
# Rake::FileList
#   .new(File.expand_path('../app/controllers/*_controller.rb', __FILE__))
#   .pathmap('%{_controller,}n')
#   .each do |route|
#     ctrl_class = "#{route}_controller".classify
#     map("/#{route}") { use ctrl_class.constantize }
# end

map('/') { run StaticController }
map_controller('/sessions')
map_controller('/users')
map_controller('/user_article_solds')
map_controller('/user_article_watcheds')
map_controller('/user_article_notifieds')
map_controller('/merchants')
map_controller('/merchant_metadata')
map_controller('/articles')
map_controller('/article_notification_criteria')
map_controller('/crawl_histories')
map_controller('/index_pages')
map_controller('/exchange_rates')

if BuymaInsider.development?
  map('/sidekiq') { run Sidekiq::Web }
end
