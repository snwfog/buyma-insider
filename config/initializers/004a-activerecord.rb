ActiveRecord::Base.logger = BuymaInsider.logger_for(:Database)

ActiveRecord::Base.establish_connection(BuymaInsider.configuration.postgres)