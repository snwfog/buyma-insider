ActiveRecord::Base.logger = BuymaInsider.logger_for(:Database)

unless defined? Unicorn::HttpServer
  # if there is unicorn, db connection is established after fork
  ActiveRecord::Base.establish_connection(BuymaInsider.configuration.postgres)
end
