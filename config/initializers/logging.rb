require 'logging'

Logging.logger.root.appenders = Logging.appenders.rolling_file("./log/buyma-insider-#{ENV['ENVIRONMENT']}.log", :age => 'weekly')
Logging.logger.root.level = :info

worker = Logging.logger['worker']
worker.appenders = Logging.appenders.rolling_file("./log/workers-#{ENV['ENVIRONMENT']}.log", :age => 'weekly')
worker.level = :info


