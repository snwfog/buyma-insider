ActiveRecord::Base.logger = BuymaInsider.logger_for(:Database)

unless defined? Unicorn::HttpServer
  # if there is unicorn, db connection is established after fork
  # other places needs to hook connection explicitly: sidekiq, pry
  ActiveRecord::Base.establish_connection(BuymaInsider.configuration.postgres)
end
